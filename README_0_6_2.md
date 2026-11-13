# Crónicas do Trono Fragmentado — MVP 0.6.2

## Expansão do mundo
- Mapa autoritativo ampliado de 960×640 para **1920×1280**.
- Câmara suave que acompanha o personagem, com limites de mapa e HUD fixo.
- Bairros a leste e a sul: casas, árvores, rochas, arbustos, barris, cercas, bancas de mercado e poço.
- Novos pontos de aparecimento de lobos e saqueadores fora da área original.
- A* expandido para 120×80 células (16 px por célula), mantendo os obstáculos espelhados entre cliente e servidor.
- Clique direito convertido de coordenadas do ecrã para coordenadas do mundo.
- Textos de dano desenhados sobre o mundo; interface de inventário, loja e missões permanece fixa.
- Persistência SQLite centralizada e equipamentos preservados.

## Instalação
1. Fecha o servidor e o Godot.
2. Faz backup da base `C:\Projects\TronoFragmentado\data\characters.sqlite3`.
3. Extrai este ZIP numa nova pasta.
4. Executa em `mvp/server`: `python -m uvicorn main:app --host 127.0.0.1 --port 8000`.
5. Abre `mvp/client/project.godot` no Godot e executa com F5.

## Testes
- Caminha até à margem direita e ao sul; a câmara deve acompanhar o herói.
- Clique direito em destinos distantes e verifica A* e obstáculos.
- Testa o auto-combate perto dos novos lobos e saqueadores.
- Abre inventário e missões enquanto a câmara está deslocada.
- Verifica textos flutuantes e o progresso guardado após reiniciar.

## Limites desta versão
O mapa utiliza quatro blocos de textura de terreno e os mesmos recursos gráficos; as novas áreas são uma primeira expansão explorável, não mapas independentes nem transições entre regiões. O Godot não foi executado neste ambiente, pelo que a validação funcional continua pendente.
