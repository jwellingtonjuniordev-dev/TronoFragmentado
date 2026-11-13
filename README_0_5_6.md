# MVP 0.5.6 — Combate automático

- `T`: alterna combate automático. Inicia desligado por segurança.
- Deteta o monstro vivo mais próximo num raio de 180 px.
- Se estiver fora do alcance, aproxima-se usando o A* do MVP 0.5.5.
- Dentro de 57 px, envia ataques a cada 0,60 s. O servidor valida o alcance real (65 px), cooldown, vida e dano.
- O alvo fica marcado com um círculo vermelho e o HUD indica `AUTO: ON`.
- `WASD` tem prioridade enquanto estiver pressionado; clique direito desliga o combate automático e define um novo destino.
- NPCs amigáveis não são alvos. O modo automático inicia desligado a cada sessão.
- Não altera o esquema SQLite nem os dados dos personagens.

## Testes recomendados
1. Abrir o jogo e confirmar nível/ouro/equipamentos.
2. Premir T perto de um lobo e confirmar aproximação, ataque e loot.
3. Premir T novamente e confirmar paragem.
4. Premir WASD enquanto o modo está ligado; verificar prioridade manual.
5. Clicar com botão direito; verificar que o modo automático desliga.
6. Confirmar que Tessa nunca é atacada.
7. Reiniciar servidor e verificar persistência.

**Nota:** a seleção do inimigo atingido continua a ser feita pelo servidor (inimigo mais próximo dentro de 65 px).
