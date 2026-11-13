# MVP 0.6.2.1 — Correção da câmara e das sombras

Corrigida a função `draw_ellipse_shadow`: anteriormente repunha a transformação para `Vector2.ZERO`, fazendo com que os elementos desenhados depois da primeira sombra deixassem de acompanhar a câmara. Agora as sombras usam `camera_offset` e restauram a transformação do mundo.

Não foram alterados servidor, colisões, A*, combate ou SQLite.

## Testes
1. Caminhar para leste e sul e observar se casas, Tessa, árvores e monstros mantêm posições coerentes com as estradas.
2. Aproximar-se de uma casa e confirmar que não desliza em relação ao chão.
3. Clicar para caminhar com a câmara deslocada.
4. Verificar combate automático e HUD fixo.

Se houver outros desalinhamentos, enviar uma captura e a mensagem de erro do Godot, se existir.
