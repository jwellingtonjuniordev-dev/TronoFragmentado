# MVP 1.0.0 — Pulso telegrafado do Guardião

- O Guardião anuncia o pulso com um círculo vermelho no chão, visível para todos os jogadores.
- Há 1,65 s na fase 1, 1,35 s na fase 2 e 1,10 s na fase 3 para sair da área.
- O Guardião fica parado durante a preparação; o servidor verifica a posição de todos os jogadores no momento do impacto.
- Jogadores fora do círculo não recebem dano. Os dentro recebem dano calculado com a sua defesa.
- Preserva as fases, os sistemas anteriores e o formato da SQLite.

Teste: aproxime-se do Guardião, aguarde o aviso vermelho, saia do círculo antes do impacto; repita ficando dentro, e confirme o dano.

Validação: sintaxe Python e integridade do ZIP; execução no Godot deve ser testada localmente.
