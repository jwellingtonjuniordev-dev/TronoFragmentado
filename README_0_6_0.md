# MVP 0.6.0 — Reformulação gráfica (pixel art detalhado)

## O que mudou
- Terreno texturizado em pixel art, com ruas de calçada irregular, relva, ervas e flores.
- Quatro casas ilustradas com telhados de telha, estrutura de madeira, portas, janelas, chaminés e lanternas.
- Árvores ilustradas com copa, volume e iluminação.
- Novas spritesheets originais para herói, Tessa, saqueador e lobo (4 direções x 4 frames).
- Ícones de itens desenhados para espada, escudo, armadura, poção, pele e tecido.
- Filtro de textura nearest para preservar os pixels.
- **Não alterámos** as coordenadas, as colisões, o servidor Python, o A*, o combate automático, a base SQLite ou os efeitos flutuantes.

## Instalação
1. Desligar servidor e Godot. Fazer backup da base centralizada `C:\Projects\TronoFragmentado\data\characters.sqlite3`.
2. Extrair este ZIP para uma nova pasta.
3. Na pasta `mvp/server`, executar `python -m uvicorn main:app --host 127.0.0.1 --port 8000`.
4. Abrir `mvp/client/project.godot` no Godot 4 e executar F5.
5. Verificar aspeto das casas, árvores, personagens e ícones, e depois combate, navegação, inventário e persistência.

Nota: o cliente ainda utiliza um único Node2D com desenho customizado. Esta versão é uma renovação visível dos recursos gráficos, não uma migração completa para TileMapLayer/AnimatedSprite2D. O teste final de importação/renderização deve ser realizado no Godot.
