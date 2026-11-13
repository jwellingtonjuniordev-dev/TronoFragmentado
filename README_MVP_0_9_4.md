# MVP 0.9.4 — Combate especializado por classe

Guerreiro: Corte Heroico atinge até 3 inimigos, num raio de 78 px do alvo principal. Os alvos secundários recebem 75% do dano.

Mago: Explosão Arcana atinge até 6 inimigos, num raio de 110 px do alvo principal. Os alvos secundários recebem 65% do dano.

Arqueiro: Flecha Precisa continua a ser ataque de alvo único, com alcance 145 px; o projétil visual viaja da posição do personagem até ao alvo. O dano é validado imediatamente no servidor, não quando a animação chega.

Todos os alvos são selecionados pelo servidor. O loot e a experiência são atribuídos normalmente por cada monstro derrotado. Não altera os controlos ou a base de dados.

Testar no Godot 4.7.2; não houve teste de execução do Godot neste ambiente. Fazer cópia de segurança da SQLite.
