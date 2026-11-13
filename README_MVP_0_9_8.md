# MVP 0.9.8 — Recompensas por queimadura

- Dano periódico de queimadura agora atribui XP, ouro, loot e progresso de missões ao jogador responsável, desde que esteja ligado e vivo.
- A mesma função no servidor atribui recompensas por golpes diretos e dano periódico.
- Evita dupla atribuição de recompensas: o monstro deixa de estar vivo no momento da morte.
- Efeitos visuais, classes, habilidades e árvore de talentos preservados.
- A base SQLite não é incluída. Faz backup antes de substituir o servidor.
- Testes efetuados: compilação de Python e integridade do ZIP. Teste de integração no Godot pendente.
