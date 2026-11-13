# MVP 0.7.1 — Ferramentas e especialização

Partindo do MVP 0.7.0 testado pelo utilizador, adicionámos três receitas à forja:

- Machado de lenhador: 12 Fragmentos de madeira + 2 Barras de ferro; 80% sucesso; requer Lenhador nível 3. Enquanto estiver na mochila, cada árvore rende 4 fragmentos em vez de 3.
- Picareta de mineiro: 12 Fragmentos de rocha + 3 Barras de ferro; 75% sucesso; requer Mineiro nível 3. Enquanto estiver na mochila, a probabilidade de minério sobe de 70% para 80%.
- Kit de herbalista: 2 Ervas raras + 2 Tábuas de madeira; 65% sucesso; requer Herbalista nível 3. Enquanto estiver na mochila, a probabilidade de erva sobe de 20% para 30%.

As ferramentas são itens passivos de profissão, não substituem espada, escudo nem armadura. Para fabricar, ir ao Ferreiro, E > Fabricar, e usar a roda do rato para percorrer as receitas. O painel P informa quando a ferramenta está desbloqueada.

As receitas consomem materiais mesmo se a tentativa falhar, como as restantes receitas. Não alterámos a experiência recebida por profissão, o cooldown de 40 segundos, nem o dia/noite.

## Instalação
1. Fechar servidor e Godot e guardar cópia da base de dados centralizada. A base não vem no ZIP.
2. Extrair em nova pasta e executar o servidor em `mvp/server` com `python -m uvicorn main:app --host 127.0.0.1 --port 8000`.
3. Abrir `mvp/client/project.godot` no Godot 4 e executar F5.
4. Testar crafting com nível insuficiente, crafting com nível >= 3, bónus de cada ferramenta, inventário, missões e persistência.

Validação: compilação Python e integridade do ZIP. Não foi possível executar Godot neste ambiente.
