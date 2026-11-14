# MVP 1.0.4.3 — Progressão automática na Cripta

## Causa confirmada
Um herói de nível elevado derrota o Esqueleto Errante (90 HP) com um golpe. O servidor definia `dungeon_active = False` após **qualquer** sala concluída, fazendo desaparecer o painel. O jogador interpretava o encerramento como falha de ataque.

## Correção
- Salas 1, 2 e 3: o painel mantém-se aberto e a próxima sala inicia automaticamente.
- O herói e o inimigo são reposicionados; o inimigo recebe a vida da nova etapa e o temporizador de ataque reinicia.
- A Cripta fecha apenas na vitória final (sala 4) ou ao escolher sair (3).
- Recompensa única e progressão individual são preservadas, sem alteração de SQLite.

## Validação
- Compilação Python: OK.
- Integração WebSocket (FastAPI TestClient): quatro vitórias consecutivas, transição automática e fecho apenas na quarta sala: OK.
- Integridade do ZIP: OK.
- Teste visual Godot: pendente.

**Código corrigido:** entregue no ZIP MVP 1.0.4.3; publicação integral do código no GitHub ainda não confirmada.
