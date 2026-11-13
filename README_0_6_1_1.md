# MVP 0.6.1.1 — Correção de animação das pernas

- Passadas dos humanoides redesenhadas, com alternância visível dos pés.
- A animação mantém-se ativa durante 0,19 s entre snapshots do servidor, em vez de reiniciar a cada atualização sem deslocamento.
- O sprite regressa ao repouso quando o personagem pára.
- Não altera servidor, SQLite, combate, navegação ou colisões.

Instalação: extrair em nova pasta, iniciar o servidor a partir de mvp/server e abrir mvp/client/project.godot no Godot. Testar WASD, clique direito e auto-combate.
