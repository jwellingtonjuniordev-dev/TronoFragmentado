@echo off
setlocal
cd /d "%~dp0"
echo [Trono Fragmentado] Preparar servidor no Windows
where py >nul 2>&1
if errorlevel 1 (
  echo ERRO: Python Launcher nao encontrado. Instala Python 3.12 de python.org.
  pause
  exit /b 1
)
py -3.12 --version >nul 2>&1
if errorlevel 1 (
  echo ERRO: Python 3.12 nao encontrado. Instala Python 3.12 e tenta novamente.
  pause
  exit /b 1
)
if not exist ".venv\Scripts\python.exe" (
  echo A criar ambiente virtual com Python 3.12...
  py -3.12 -m venv .venv
  if errorlevel 1 goto :fail
) else (
  ".venv\Scripts\python.exe" --version | findstr /C:"3.12." >nul
  if errorlevel 1 (
    echo ERRO: O .venv existente nao utiliza Python 3.12.
    echo Renomeia a pasta .venv para .venv-antigo e volta a executar.
    pause
    exit /b 1
  )
)
echo A atualizar pip...
".venv\Scripts\python.exe" -m pip install --upgrade pip
if errorlevel 1 goto :fail
echo A instalar dependencias do servidor...
".venv\Scripts\python.exe" -m pip install -r requirements.txt
if errorlevel 1 goto :fail
".venv\Scripts\python.exe" -m pip check
if errorlevel 1 goto :fail
".venv\Scripts\python.exe" -m uvicorn --version
if errorlevel 1 goto :fail
echo.
echo INSTALACAO CONCLUIDA. O ambiente virtual esta pronto.
echo Para iniciar, usa: .venv\Scripts\python.exe -m uvicorn main:app --host 127.0.0.1 --port 8000
pause
exit /b 0
:fail
echo ERRO: Instalacao interrompida. Le a mensagem acima.
pause
exit /b 1
