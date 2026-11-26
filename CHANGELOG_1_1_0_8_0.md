# MVP 1.1.0.8.0
Base: MVP 1.1.0.7.9. Mantidos os assets, personagens, cenas e servidor.

## Alterações
- Habilidade 1: 9 segundos de cooldown; habilidade 2: 7 segundos para todas as classes. Servidor autoritativo e HUD sincronizados pelo evento `skill_cast`.
- Recursos recolhíveis (madeira, minério e ervas) limitados à região florestal sudeste, com exclusão do corredor da estrada. Recursos persistidos anteriormente são reposicionados ao carregar o mundo, mantendo os IDs e tipos.
- Clique esquerdo: seleciona/ataca inimigos, recolhe recursos próximos ou define caminho; para recursos distantes, aproxima e solicita novo clique. WASD e G mantidos.
- Clique direito: já não desloca o herói; preserva venda de itens no inventário junto do ferreiro.
- Soldados das três primeiras salas da cripta utilizam o mesmo atlas de movimento e ataque do Saqueador. Velkran mantém-se na sala final.

## Ficheiros alterados
- `mvp/client/scripts/main.gd`
- `mvp/server/main.py`

## Checklist
1. Iniciar servidor em `mvp/server`: `python -m uvicorn main:app --host 127.0.0.1 --port 8000`.
2. Abrir `mvp/client/project.godot` no Godot e executar F5.
3. Usar habilidades 1 e 2 e confirmar bloqueios de 9s e 7s no servidor e HUD.
4. Clicar no chão com botão esquerdo: herói move-se. Botão direito no chão: não move.
5. Clicar num inimigo: selecionar/seguir/atacar. Clicar num recurso próximo: recolher. Distante: aproximar e clicar novamente.
6. Abrir inventário junto ao ferreiro e clicar com botão direito num item vendável.
7. Verificar recursos apenas na floresta e fora da estrada, inclusive após reiniciar o servidor.
8. Entrar na cripta: soldados com atlas do Saqueador, Velkran preservado na sala 4.

## Limitações de validação
Sintaxe Python verificada. Godot não está disponível no ambiente de empacotamento; validar o GDScript no editor.
