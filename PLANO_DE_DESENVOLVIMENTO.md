# Crónicas do Trono Fragmentado — Plano de produção

## Estado real
O projeto é um protótipo jogável, não um MMORPG completo. O MVP 0.9.9 introduz as primeiras fases do Guardião, sem alterar o esquema SQLite. O cliente precisa de teste no Godot.

## Próximas entregas necessárias
1. Narrativa canónica: capítulos, personagens, facções, diálogos ramificados e final da campanha. Requer confirmação do documento original da história para não inventar o cânone.
2. Mundo: mapas por regiões, transições, dungeons instanciadas, bosses, puzzles e fast travel.
3. Combate: telegráficos de área, animações próprias, IA de monstros, balanceamento de classes e PvE cooperativo.
4. Progressão: árvore de habilidades, classes avançadas, equipamentos, crafting, economia, profissões e quests completas.
5. Multiplayer: grupos, chat, guildas, sincronização de mundo, autenticação segura e prevenção de trapaças.
6. Produto: menus, configurações, áudio, acessibilidade, arte consistente, testes, documentação e empacotamento.

## Segurança e persistência
Preservar sempre `server/characters.sqlite3` e backups antes de instalar versões. Não expor o servidor público sem autenticação, rate limiting e revisão de segurança.

## Testes manuais MVP 0.9.9
- Fase 1: HP acima de 60%; pulso a cada 9 s, raio 92, dano base 28.
- Fase 2: HP a 60% ou menos; anúncio; pulso a cada 7 s, raio 115, dano base 35.
- Fase 3: HP a 25% ou menos; anúncio; pulso a cada 5 s, raio 135, dano base 43; movimentação acelerada.
- Respawn reinicia na fase 1; ataque por clique, loot, missões e SQLite continuam.
