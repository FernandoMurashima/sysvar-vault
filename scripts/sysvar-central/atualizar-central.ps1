#requires -Version 7.0
<#
.SYNOPSIS
    Atualizacao automatizada do Sysvar Central no Viper-II.
.DESCRIPTION
    Por padrao valida o ambiente sem implantar. -Aplicar faz build Angular
    no Windows e publica Backend/Frontend no Docker do Viper-II.
    Nao altera, recria ou migra bancos de dados.
.EXAMPLE
    .\atualizar-central.ps1
.EXAMPLE
    .\atualizar-central.ps1 -Aplicar
#>
[CmdletBinding()]
param(
    [switch]$Aplicar,
    [string]$Servidor = '192.168.1.135',
    [string]$Usuario = 'fernando-murashima'
)

$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest

$BackendWindows  = 'C:\SysvarProjeto\Backend'
$FrontendWindows = 'C:\SysvarProjeto\Frontend\sysvar'
$NavegadorBuild  = Join-Path $FrontendWindows 'dist\sysvar\browser'
$DeployBash      = Join-Path $PSScriptRoot 'deploy-viper-ii.sh'
$Destino = "$Usuario@$Servidor"

function Executar([string]$Comando, [string[]]$Argumentos) {
    & $Comando @Argumentos
    if ($LASTEXITCODE -ne 0) { throw "$Comando falhou (codigo $LASTEXITCODE)." }
}

function Git-Limpo-Atual([string]$Pasta, [string]$Nome) {
    $DentroGit = & git -C $Pasta rev-parse --is-inside-work-tree 2>$null
    if ($LASTEXITCODE -ne 0 -or $DentroGit -ne 'true') {
        throw "Repositorio $Nome nao encontrado: $Pasta"
    }
    $Status = & git -C $Pasta status --porcelain
    if ($LASTEXITCODE -ne 0) { throw "Falha no git status: $Nome" }
    if ($Status) { throw "$Nome tem alteracoes locais. Publique ou resolva antes do deploy; nada sera descartado." }

    $Ramo = (& git -C $Pasta branch --show-current).Trim()
    if ($LASTEXITCODE -ne 0 -or $Ramo -ne 'main') { throw "$Nome precisa estar na branch main." }

    $Local = (& git -C $Pasta rev-parse HEAD).Trim()
    if ($LASTEXITCODE -ne 0) { throw "Falha ao consultar commit local: $Nome" }
    $RemotoRef = & git -C $Pasta ls-remote origin refs/heads/main
    if ($LASTEXITCODE -ne 0 -or -not $RemotoRef) { throw "Nao consegui verificar origin/main: $Nome" }
    $Remoto = (($RemotoRef -join "`n") -split '\s+')[0]
    if ($Local -ne $Remoto) { throw "$Nome difere do GitHub. Sincronize o repositorio antes do deploy." }
    Write-Host "$Nome OK: $($Local.Substring(0,10))"
}

$Temporario = $null
try {
    foreach ($Programa in @('git.exe', 'npm.cmd', 'npx.cmd', 'ssh.exe', 'scp.exe', 'tar.exe')) {
        if (-not (Get-Command $Programa -ErrorAction SilentlyContinue)) {
            throw "Ferramenta nao encontrada: $Programa"
        }
    }
    if (-not (Test-Path (Join-Path $FrontendWindows 'angular.json'))) {
        throw "Angular nao encontrado: $FrontendWindows"
    }
    if (-not (Test-Path (Join-Path $FrontendWindows 'node_modules\.bin\ng.cmd'))) {
        throw 'Dependencias Angular ausentes (node_modules). Instale-as antes do deploy.'
    }
    if (-not (Test-Path $DeployBash)) { throw "Arquivo complementar ausente: $DeployBash" }

    Git-Limpo-Atual $BackendWindows 'Central Backend'
    Git-Limpo-Atual $FrontendWindows 'Central Frontend'

    Write-Host 'Verificando conexao e containers do Viper-II...'
    Executar 'ssh.exe' @($Destino, 'test -d /srv/projects/sysvar/backend/.git && test -f /srv/projects/sysvar/frontend/Dockerfile && test -f /srv/projects/sysvar/backend/.env && docker container inspect sysvar-backend sysvar-frontend mysql >/dev/null && docker network inspect infra >/dev/null && echo VIPER_OK')

    if (-not $Aplicar) {
        Write-Host 'Verificacao aprovada. Para atualizar: .\atualizar-central.ps1 -Aplicar'
        exit 0
    }

    $Confirmacao = Read-Host 'Atualizar agora o Sysvar Central no Viper-II? Digite ATUALIZAR'
    if ($Confirmacao -cne 'ATUALIZAR') { throw 'Operacao cancelada pelo operador.' }

    Write-Host 'Compilando Frontend Angular de producao...'
    Push-Location $FrontendWindows
    try { Executar 'npx.cmd' @('ng', 'build', '--configuration', 'production') }
    finally { Pop-Location }
    if (-not (Test-Path (Join-Path $NavegadorBuild 'index.html'))) {
        throw "Build Angular sem index.html: $NavegadorBuild"
    }

    $Identificador = Get-Date -Format 'yyyyMMddHHmmss'
    $Temporario = Join-Path ([System.IO.Path]::GetTempPath()) "sysvar-deploy-$Identificador"
    New-Item -ItemType Directory -Path $Temporario -Force | Out-Null
    $ArquivoBuild = Join-Path $Temporario 'frontend.tgz'
    Executar 'tar.exe' @('-czf', $ArquivoBuild, '-C', $NavegadorBuild, '.')

    $DestinoTemp = "/tmp/sysvar-central-$Identificador"
    Write-Host 'Enviando build e rotina de deploy ao Viper-II...'
    Executar 'ssh.exe' @($Destino, "mkdir -m 700 -- '$DestinoTemp'")
    Executar 'scp.exe' @($ArquivoBuild, "${Destino}:$DestinoTemp/frontend.tgz")
    Executar 'scp.exe' @($DeployBash, "${Destino}:$DestinoTemp/deploy-viper-ii.sh")

    Write-Host 'Construindo imagens e implantando a Central...'
    Executar 'ssh.exe' @($Destino, "bash '$DestinoTemp/deploy-viper-ii.sh' '$Identificador' '$DestinoTemp'")
    Write-Host 'Deploy concluido. Banco de dados NAO alterado.'
} catch {
    Write-Error "ATUALIZACAO INTERROMPIDA: $($_.Exception.Message)" -ErrorAction Continue
    exit 1
} finally {
    if ($Temporario -and (Test-Path $Temporario)) {
        Remove-Item -LiteralPath $Temporario -Recurse -Force -ErrorAction SilentlyContinue
    }
}