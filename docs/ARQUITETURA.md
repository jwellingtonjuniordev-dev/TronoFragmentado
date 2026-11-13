# Arquitetura

Godot 4 (GDScript) comunica com FastAPI via WebSocket JSON. O servidor Python valida movimento, combate, efeitos de estado, recompensas e missões. A SQLite armazena personagens e mundo.

- `client/scripts/main.gd`: interface, animações, input, navegação e representação de estado.
- `server/main.py`: simulação autoritativa, validações, recompensas e persistência.
- `server/requirements.txt`: dependências Python.

**Limites atuais:** protótipo local sem autenticação de produção, sem instâncias reais de dungeon e sem infraestrutura de escala. Não publicar o servidor na internet sem implementar segurança.
