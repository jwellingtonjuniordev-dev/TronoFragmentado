# Executar dentro da pasta mvp, depois de extrair o ZIP.
# Requer Git instalado e autenticacao GitHub configurada no computador.
$ErrorActionPreference = 'Stop'
$repo = 'https://github.com/jwellingtonjuniordev-dev/TronoFragmentado.git'
$source = Split-Path -Parent $MyInvocation.MyCommand.Path
$target = Join-Path (Split-Path -Parent $source) 'TronoFragmentado-github'
if (Test-Path $target) {
    Write-Host "A pasta $target ja existe. Nao vou sobrescrever um clone existente." -ForegroundColor Yellow
    exit 1
}
& git clone $repo $target
if ($LASTEXITCODE -ne 0) { throw 'Falha no clone. Confirma autenticacao GitHub.' }
# A distribuicao nao contem SQLite, segredos nem caches do Godot.
Get-ChildItem -LiteralPath $source -Force | Where-Object { $_.Name -notin @('.git','.godot','__pycache__','.venv','backups','data') } | ForEach-Object {
    Copy-Item -LiteralPath $_.FullName -Destination $target -Recurse -Force
}
Push-Location $target
try {
    & git add .
    & git status --short
    Write-Host 'Revê a lista acima. Confirmar publicacao? (S/N)'
    $answer = Read-Host
    if ($answer -notin @('S','s','sim','SIM')) { Write-Host 'Publicacao cancelada.'; exit 0 }
    & git commit -m 'feat: publicar MVP 1.0.1 e documentacao completa'
    if ($LASTEXITCODE -ne 0) { throw 'Falha no commit. Verifica git user.name e user.email.' }
    & git push origin main
    if ($LASTEXITCODE -ne 0) { throw 'Falha no push. Confirma permissao e autenticacao GitHub.' }
    Write-Host 'Projeto publicado no GitHub.' -ForegroundColor Green
} finally { Pop-Location }
