# MVP 1.0.4.3 — Progressão automática entre salas da Cripta

## Diagnóstico
Ao pressionar 1 perto do Esqueleto Errante, um herói de nível elevado derrota o inimigo com um golpe. O servidor definia `dungeon_active = False` depois de **cada** vitória, fechando o painel e obrigando a pressionar K novamente. Isso parecia uma falha de ataque.

## Correção
- O servidor mantém `dungeon_active = True` ao vencer as salas 1, 2 e 3.
- A sala seguinte começa automaticamente, com John em [1,2], novo inimigo em [8,2], HP correspondente à etapa e temporizador de ataque reiniciado.
- A Cripta só fecha ao concluir a sala 4 ou ao pressionar 3.
- A recompensa única da sala final continua protegida contra duplicação.
- O texto da interface indica a passagem automática entre salas.
- A progressão da dungeon permanece independente por personagem e não requer migração SQLite.

## Testes
- Compilação Python: passou.
- Teste de integração WebSocket com FastAPI TestClient: passou nas quatro salas, incluindo transições e fecho final.
- Integridade ZIP: passou.
- Godot: validação visual pendente no computador do jogador.

## Instalação
Faz backup de `data/characters.sqlite3` com o servidor parado. Substitui `mvp/server/main.py` e `mvp/client/scripts/main.gd` pela versão atualizada. Reinicia o servidor e o Godot.
