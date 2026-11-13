# MVP 0.9.5 — Talento exclusivo por classe

Abre B e desbloqueia o talento da classe ao atingir maestria nível 2 (16 acertos), depois de Poder.

- Guerreiro — Vigor: recupera 10% do dano causado por Corte Heroico, limitado ao HP máximo.
- Mago — Sintonia Arcana: recupera 8 MP por Explosão Arcana validada.
- Arqueiro — Precisão: +20% de dano de Flecha Precisa contra o Guardião.

A seleção e o efeito são validados no servidor. O progresso e o talento são persistidos na SQLite atual. A árvore de talentos e os controlos anteriores permanecem.

Faz backup da SQLite antes de executar. O ZIP não inclui bases de dados, nem caches do Godot.

Verificado: compilação Python e integridade ZIP. A execução do Godot deve ser testada localmente.
