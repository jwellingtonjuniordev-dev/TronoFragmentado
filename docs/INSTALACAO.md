# Instalação local (Windows)

Requisitos: Python 3.11+ e Godot 4.

Na pasta `server`:

```powershell
py -m venv .venv
.\.venv\Scripts\python.exe -m pip install -r requirements.txt
.\.venv\Scripts\python.exe -m uvicorn main:app --host 127.0.0.1 --port 8000
```

Confirma `http://127.0.0.1:8000/health`. Abre `client/project.godot` no Godot e inicia a cena principal. Usa **N** para carregar o personagem, **E** para interagir e **Q** para as missões.

Não incluas a SQLite no Git; faz backup com o servidor parado. O servidor aceita `TRONO_DATA_DIR` para definir o diretório de dados.
