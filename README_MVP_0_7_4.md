# MVP 0.7.4 — Comércio por clique direito

- Perto do Ferreiro (até 90 unidades), abre a mochila com I e clica com o botão direito num item para solicitar a venda.
- Confirma ou cancela na janela de confirmação. ESC cancela.
- Na loja do Ferreiro, escolhe previamente um lote 1x, 5x, 10x, 20x ou 50x; o servidor valida quantidade, proximidade e se o item pode ser vendido.
- A loja apresenta apenas equipamentos para compra. Novos: Armadura de ferro (650 ouro, +16 defesa), Escudo reforçado de aço (850 ouro, +19 defesa), Espada de aço do Guardião (1250 ouro, +32 ataque).
- Itens raros não vendidos anteriormente continuam protegidos contra venda.
- A SQLite não está incluída. Faz cópia de segurança antes de executar.
- O Python foi compilado para verificar sintaxe; a execução no Godot deve ser testada no computador.
