# Guia de instalação Windows — MVP 1.0.5.9

## Pré-requisitos
- Windows 10/11, Python **3.12** instalado pelo python.org com o Python Launcher (`py`), Git (apenas para sincronização) e Godot 4 compatível com o projeto.
- O Python 3.15 pode provocar compilação do PyYAML e erros de Microsoft Visual C++ 14.0. Recomenda-se Python 3.12.

## Instalação automática do servidor (recomendado)
1. Extrai o ZIP do MVP numa pasta, por exemplo `C:\Projects\TronoFragmentado`.
2. Entra na pasta `mvp\server`.
3. Executa `INSTALAR_WINDOWS.bat` com duplo clique. Não requer ativar o ambiente virtual nem modificar a política do PowerShell.
4. O instalador verifica Python 3.12, cria `.venv` se necessário, instala `requirements.txt` e valida `uvicorn`.
5. Inicia o servidor no PowerShell aberto em `mvp\server`:

```powershell
.\.venv\Scripts\python.exe -m uvicorn main:app --host 127.0.0.1 --port 8000
```

## Instalação manual
```powershell
cd C:\Projects\TronoFragmentado\mvp\server
py -3.12 -m venv .venv
.\.venv\Scripts\python.exe -m pip install --upgrade pip
.\.venv\Scripts\python.exe -m pip install -r requirements.txt
.\.venv\Scripts\python.exe -m uvicorn --version
```

Se o `.venv` foi copiado de outro computador, **renomeia-o** para `.venv-antigo` e cria um novo. Não apagues ficheiros SQLite nem backups.

## Erro `Activate.ps1` bloqueado
A opção preferencial é **não ativar** o ambiente: usa `.\.venv\Scripts\python.exe` diretamente. Se precisares de ativar na sessão atual do PowerShell:
```powershell
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
.\.venv\Scripts\Activate.ps1
```
A alteração `-Scope Process` é temporária e termina ao fechar a janela. Políticas de grupo podem impedir essa opção.

## Erro `No module named uvicorn`
Significa que o Python usado para arrancar não tem o módulo. Usa o executável do `.venv`, e confirma:
```powershell
.\.venv\Scripts\python.exe -m pip show uvicorn
.\.venv\Scripts\python.exe -m uvicorn --version
```

## Cliente Godot
Abre a pasta `mvp\client` no Godot, importa o projeto e executa-o com o servidor já iniciado. Confirma a configuração do endereço WebSocket do cliente quando o servidor estiver noutro computador.

## Publicação GitHub
Após validação, executa `mvp\SINCRONIZAR_GITHUB.bat`, confirma o diff e verifica o commit no repositório. O sincronizador exclui `.venv`, SQLite, `.env` e backups. O instalador está dentro de `server` e o guia dentro de `docs`, portanto ambos são sincronizados.
