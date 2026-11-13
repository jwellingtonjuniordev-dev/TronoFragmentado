# Crónicas do Trono Fragmentado — MVP 0.6.9.5

## Novidades
- Recursos físicos partilhados pelo servidor: 43 árvores, 22 rochas (14 adicionais), 11 ervas. São gerados em posições seguras e aleatórias quando necessário.
- Ao recolher com G, a árvore, rocha ou erva desaparece, incluindo a colisão, durante 40 segundos; depois reaparece noutra posição segura, afastada da anterior.
- Posições e temporizadores dos recursos guardados na SQLite centralizada (tabela `world_state`). Os dados do personagem não são apagados.
- Posicionamento evita edifícios, ruínas, baús, NPCs, cercas, barris, personagens e monstros; o caminho principal também é protegido.
- Minério continua a ter 70% de sucesso; se falhar, a rocha dá 3 fragmentos de rocha. Árvores dão 3 fragmentos de madeira; ervas 20%.
- Adaga enferrujada: probabilidade de drop de saqueador aumentada de 15% para 20%.
- Novas receitas: Escudo do saqueador (4 adagas, 3 barras, 2 tábuas, 25%, +13 defesa) e Espada do saqueador (6 adagas, 4 barras, 3 presas, 12%, +25 ataque).
- Venda de lotes de 1, 5, 10, 20 e 50 unidades de itens comuns e armas normais. Escolhe lote e clica no item na loja do Ferreiro. Roda do rato para segunda página.
- Equipamentos raros, drops raros e itens de missão não podem ser vendidos.
- Efeito dia/noite preservado e erro de tipagem da variável `lamp` corrigido.

## Instalação
1. Fecha o Godot e o servidor anterior.
2. Faz backup da base SQLite centralizada antes de testar (normalmente `C:\Projects\TronoFragmentado\data\characters.sqlite3`, ou `%USERPROFILE%\TronoFragmentado\data\characters.sqlite3`; a localização exata aparece no log do servidor).
3. Extrai o ZIP numa pasta nova; não substituas a base de dados por ficheiros antigos.
4. Em `mvp/server`: `python -m uvicorn main:app --host 127.0.0.1 --port 8000`.
5. Abre `mvp/client/project.godot` no Godot 4 e executa F5.

## Testes
- Aproxima-te de uma árvore e pressiona G; ela deve desaparecer e permitir passagem pelo local.
- Espera 40 segundos; ela deve reaparecer noutro local seguro.
- Faz o mesmo com rochas e ervas; testa reiniciar o servidor durante o cooldown.
- Derrota saqueadores para tentar conseguir adagas (20% por morte).
- No Ferreiro, escolhe Comprar/Vender; seleciona 5x, 10x, 20x ou 50x e clica numa arma normal ou material. Se não tiveres a quantidade, o servidor recusa sem perder itens.
- Na forja, verifica as duas receitas novas.
- Confirma a iluminação noturna, o inventário, a missão do Guardião e o progresso do John.

## Validação e limitações
- Python compilado, recursos validados contra zonas proibidas, persistência de mundo testada em SQLite isolada, ZIP verificado.
- Godot não está disponível neste ambiente: a compilação do GDScript e os testes visuais devem ser feitos no teu computador.
- O mundo de recursos é partilhado por todos os jogadores conectados, não individual por personagem.
