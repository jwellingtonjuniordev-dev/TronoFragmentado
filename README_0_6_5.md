# MVP 0.6.5 — Três baús com respawn de 5 minutos

Baús nas coordenadas do mundo (1735,1060), (1170,1010) e (1030,665). Aproxima-te e prime F para abrir o mais próximo.

Cada baú atribui 75 ouro, 60 XP e duas poções pequenas. O servidor valida a distância e aplica um cooldown individual de 300 segundos por personagem e por baú. Os prazos absolutos (Unix) são guardados no campo `chest_cooldowns` do JSON SQLite. Reiniciar o servidor não reinicia o prazo. O estado do baú aparece no cliente, incluindo contagem regressiva. Para personagens que já tinham aberto o baú antigo, a primeira tentativa de reabertura inicia uma espera de 5 minutos, sem recompensa imediata.

## Instalação

1. Para o servidor e fecha o Godot.
2. Faz cópia de segurança da base SQLite centralizada em `C:\Projects\TronoFragmentado\data\characters.sqlite3` (ou TRONO_DATA_DIR).
3. Extrai o ZIP numa pasta nova.
4. Inicia na pasta `mvp/server`: `python -m uvicorn main:app --host 127.0.0.1 --port 8000`.
5. Abre `mvp/client/project.godot` no Godot 4 e executa F5.

## Testes

- Localiza os três baús e abre cada um com F; verifica ouro, XP e poções.
- Tenta abrir o mesmo baú imediatamente: sem nova recompensa.
- Verifica o tempo restante junto ao baú.
- Reinicia servidor e cliente durante o cooldown: tempo não reinicia.
- Aguarda 5 minutos desde a abertura e recolhe novamente.
- Testa A*, combate automático, missões, inventário e progresso.

A base SQLite não é incluída. A sintaxe Python e a persistência de teste foram verificadas; a importação e a execução no Godot ainda precisam de validação.
