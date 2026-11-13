# MVP 0.9.1 — Árvore de Talentos

- Tecla B abre/fecha a árvore da classe ativa; ESC fecha.
- Clique em Poder (+5 ATQ) após alcançar Maestria nível 1 da classe (8 acertos).
- Clique em Guarda (+5 DEF) após alcançar Maestria nível 3 da classe (24 acertos) e desbloquear Poder.
- Talentos são persistidos por classe em `skill_tree` na SQLite existente.
- Os bónus só se aplicam quando a respetiva classe está ativa.
- Não altera os equipamentos, ouro ou pontos de maestria.
- Copia a SQLite antes de iniciar o servidor atualizado.
- Reimporta o projeto Godot após extrair em pasta nova.

Validação: sintaxe Python e integridade ZIP. O projeto Godot necessita de teste local.
