# MVP 1.1.0.7.7 — Correções visuais

Base: MVP 1.1.0.7.6.

- Corrigidos os nomes dos chefes: Guardião da Tempestade e Guardião do Sino Partido (kind `guardiao` mantido no protocolo).
- Removida a legenda sobreposta duplicada do Guardião da Tempestade.
- Substituídos sprites do Sino Partido por anim_bell_walk e anim_bell_attack (1024x560, 8 colunas x 4 linhas, 128x140 por célula).
- Corrigida a leitura do atlas para o tamanho real dos sprites do Sino Partido.
- Recriado SpriteFrames com regiões 128x140 e 12 animações direcionais.
- Substituídos visuais de forest_chest e ruins, preservando originais em assets/backup_mvp_1_1_0_7_6.
- Baú aberto mostrado durante cooldown, baú fechado quando disponível.
- Sem alterações na lógica de dano, loot, colisões, saves ou rede.

## Verificações
1. Abrir mvp/client/project.godot em Godot 4.7.2 e aguardar importação.
2. Executar F5 e confirmar ausência de erros de preload.
3. Conferir os dois nomes e visuais distintos dos chefes.
4. Aproximar-se de um baú, abrir com F, confirmar mudança visual e cooldown.
5. Verificar novas ruínas e combate do Guardião do Sino Partido.

Nota: as imagens enviadas do boss contêm artefactos escuros e vermelhos em alguns quadros; mantidas sem edição para não alterar a referência. O servidor não transmite animação/direção autoritativa de cada monstro. Não foi possível executar o Godot neste ambiente.
