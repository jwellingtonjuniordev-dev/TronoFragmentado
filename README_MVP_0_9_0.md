# MVP 0.9.0 — Maestria de habilidades

- Golpe Arcano e habilidade exclusiva de cada classe evoluem com acertos bem-sucedidos.
- A cada 8 acertos, +1 nível de maestria; máximo nível 5 (+25% dano da habilidade).
- A maestria de Guerreiro, Mago e Arqueiro é independente. A maestria do Golpe Arcano é partilhada.
- O servidor valida alcance, mana, cooldown e acerto; o progresso é guardado na SQLite existente.
- Abre C para ver a maestria atual e o progresso. A troca de classe continua gratuita para testes.
- Controlos preservados: clique esquerdo ataque, direito movimento, 1 Arcano, 2 classe, H vida, J mana, T auto, C classes.

Antes de iniciar: encerra o servidor e faz backup da SQLite. Este pacote não inclui qualquer base de dados.
