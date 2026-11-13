# MVP 0.5.7.1 — correção dos efeitos de combate

- Os efeitos são agora desenhados **depois** de estradas, casas, árvores e personagens, para ficarem sempre visíveis sobre o cenário.
- Números de dano e recompensas têm fundo escuro e contorno para maior legibilidade.
- Impactos com flash, anel expansivo e 8 partículas durante aproximadamente 0,42 s.
- Efeito luminoso de espada no ataque local.
- Combate automático, clique direito, inventário, servidor e persistência mantidos.

## Testes
1. Iniciar servidor e Godot normalmente.
2. Atacar lobos junto a casas, estradas e árvores; confirmar que o dano aparece acima do cenário.
3. Confirmar flash e partículas visíveis no inimigo atingido.
4. Confirmar XP e ouro flutuantes, auto-combate e navegação.

**A base SQLite não está incluída.** Fazer cópia de segurança antes de atualizar.
