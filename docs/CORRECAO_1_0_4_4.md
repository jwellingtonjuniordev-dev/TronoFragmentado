# MVP 1.0.4.4 — Respawn de monstros e mana

## Diagnóstico
Na tarefa assíncrona `simulation()`, a variável local `distance` usada no movimento da Cripta ocultava a função global `distance(p, m)` utilizada pela IA do mundo. Isso podia terminar a simulação, impedindo o respawn dos monstros mesmo com o servidor ligado.

## Alterações
- Renomeada para `dungeon_distance` dentro da simulação.
- Respawn de monstro sem posição segura tenta novamente em 3 segundos; recursos tentam novamente em 5 segundos.
- Mana máxima cresce 1 MP por nível acima de 1 (100 MP no nível 1, 145 MP no nível 46).
- Personagens existentes têm a capacidade sincronizada no carregamento, status e gravação.
- HUD reorganizado: barra vermelha de vida, barra roxa de mana, barra azul de XP.

## Validação
Sintaxe Python compilada; simulação assíncrona com monstro morto e respawn validada; ZIP íntegro. Godot requer teste no Windows.

## Publicação
O ZIP completo foi entregue na conversa. O repositório remoto ainda contém código anterior; esta atualização de documentação **não** implica sincronização do código-fonte integral.
