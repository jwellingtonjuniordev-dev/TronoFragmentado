# MVP 0.6.3 — Floresta dos Arredores

Primeira região florestal integrada ao mundo 1920 × 1280, no quadrante sudeste (x 960–1920, y 640–1280).

Novidades:
- Chão próprio de floresta, trilho sinuoso, vegetação e tonalidade distinta da vila.
- Novas árvores com colisões espelhadas no cliente e no servidor.
- Ruínas e baú decorativos (não interativos nesta fase).
- Novos pontos de aparecimento de lobos e saqueadores existentes.
- Placas do MVP 0.6.2.2, câmara, A*, combate, inventário e SQLite preservados.

Instalação: parar o servidor e o Godot, fazer backup da base SQLite central, extrair numa nova pasta, iniciar em `mvp/server` com `python -m uvicorn main:app --host 127.0.0.1 --port 8000` e abrir `mvp/client/project.godot` no Godot 4.

Testes: ir até sudeste, observar floresta e trilho, confirmar colisões nas novas árvores, testar A* por clique e combate automático com novos spawns, confirmar inventário e progresso.

Limites: não há novos tipos de monstros, loot ou transição entre mapas nesta versão. Ruínas e baú são apenas visuais. O Godot não foi executado neste ambiente.
