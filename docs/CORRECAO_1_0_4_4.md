# MVP 1.0.4.4 — Respawn de monstros e progressão de mana

## Causa do desaparecimento de monstros
Na rotina `simulation()`, a variável local `distance` usada para a Cripta ocultava a função global `distance(p, m)` utilizada pela IA dos monstros do mundo. Isso podia interromper a tarefa assíncrona de simulação: os monstros deixavam de mover-se e reaparecer. Corrigido para `dungeon_distance`.

## Robustez adicional
- Se não houver posição segura para respawn, o monstro tenta novamente após três segundos, sem encerrar a simulação.
- Se uma recolha não encontrar posição segura para renascer, tenta novamente após cinco segundos.
- Monstros são partilhados no mundo entre personagens, mas reaparecem após o tempo normal (9 s para comuns, 180 s para o Guardião).

## Mana
- Cada nível acima de 1 acrescenta **1 MP máximo** (1% da mana base de 100 MP): nível 1 = 100, nível 46 = 145.
- A atualização aplica-se também a personagens existentes ao carregar, preservando o valor atual de mana e adicionando a diferença de capacidade na primeira migração.
- HUD: vida vermelha, mana roxa e XP azul, nessa ordem.

## Testes
- `python -m py_compile server/main.py`: passou.
- Simulação assíncrona com um monstro morto e respawn após 1,3 s: passou.
- Integração visual Godot: pendente de teste no Windows.

## Instalação
Faz backup de `data/characters.sqlite3` com o servidor parado. Substitui `server/main.py` e `client/scripts/main.gd` e reinicia servidor e cliente.
