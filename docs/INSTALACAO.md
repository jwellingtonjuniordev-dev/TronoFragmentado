# Instalação e execução (Windows)

## Pré-requisitos
- Python 3.11 ou superior
- Godot 4.x (compatibilidade exata deve ser validada localmente)
- Git (opcional, para versionamento)

## Servidor
Abra o terminal na pasta `server` e execute:

```powershell
py -m venv .venv
.\.venv\Scripts\Activate.ps1
python -m pip install -r requirements.txt
python -m uvicorn main:app --host 127.0.0.1 --port 8000
```

Se o PowerShell bloquear a ativação, execute diretamente `\.venv\Scripts\python.exe -m uvicorn main:app --host 127.0.0.1 --port 8000`.

## Cliente
Abra `client/project.godot` no Godot, aguarde a importação e pressione F6/F5 conforme a cena principal configurada.

## Persistência
A base de dados é criada pelo servidor. Antes de atualizar, **copie a SQLite com o servidor parado**. Não publique bases reais no GitHub. O servidor aceita a variável `TRONO_DATA_DIR` para definir a pasta de dados.

## Diagnóstico
- `http://127.0.0.1:8000/health` deve responder quando o servidor está ativo.
- Se a ligação falhar, confirme o endereço WebSocket configurado no cliente e a porta 8000.
- Se o Godot apresentar erros de importação, reabra o projeto e aguarde a reimportação.
