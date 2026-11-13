# MVP 0.9.7 — Resistências e vantagens por classe

Os multiplicadores aplicam-se exclusivamente à habilidade especial da classe, e são validados no servidor:

| Monstro | Guerreiro | Mago | Arqueiro |
|---|---:|---:|---:|
| Lobo | 100% | 115% | 100% |
| Saqueador | 110% | 100% | 100% |
| Guardião | 85% | 75% | 90% |

- O Guardião continua imune a atordoamento.
- Queimadura do Guardião: dura 2,1 s e causa 2% do dano do golpe por tick, em vez de 3,1 s e 4%.
- Lentidão do Guardião: dura 2 s e reduz a velocidade a 70%, em vez de 4 s e 45%.
- Mensagens VULNERAVEL e RESISTIU aparecem sobre o alvo quando há modificador.
- Mantidos: combate por clique, habilidades, talentos, equipamentos, profissões e base SQLite.
- Atribuição de recompensas quando a queimadura finaliza um monstro continua uma limitação conhecida do MVP 0.9.6.
- Fazer cópia de segurança da SQLite antes de iniciar o servidor atualizado.
- Validação feita: sintaxe Python e integridade ZIP. A execução no Godot precisa de teste local.
