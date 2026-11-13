# Crónicas do Trono Fragmentado — MVP 0.6.9.3

## Melhorias
- Recolha G: marcadores sobre 8 recursos reais do cenário, incluindo 3 próximos de Valedouro.
- Madeira 100%, minério de ferro 40%, erva rara 20% por tentativa. O sucesso é sorteado no servidor; o recurso entra em cooldown de 5 minutos mesmo quando falha. O cooldown é guardado por personagem na SQLite.
- Erva rara: brilho violeta e etiqueta enquanto o recurso está disponível; quando esgotado, mostra contagem decrescente.
- Ferreiro: aproxima-te e prime E para abrir diálogo com escolhas por rato: COMPRAR/VENDER ou FABRICAR. M continua como atalho para abrir/fechar a oficina.
- Forja por clique: Barra de ferro (80%), Lâmina de presas (60%), Poção média (55%), Poção completa (15%) e Espada ancestral (3%).
- Receitas: Barra=3 minérios; Lâmina=2 presas+1 barra; Poção média=1 erva+2 poções pequenas; Poção completa=3 ervas+2 poções médias+1 fragmento de metal antigo; Espada ancestral=5 fragmentos+6 barras+8 presas+4 madeiras.
- Falhas de crafting consomem os materiais; o servidor envia mensagem explícita de sucesso/falha e o valor da probabilidade.
- Poção média recupera até 100 HP, completa recupera toda a vida; não são consumidas com HP cheio. Espada ancestral tem +38 ataque.
- Loot: texto flutuante do nome do item normal e do item raro, além de ouro e XP.
- Tessa continua responsável exclusivamente pelas missões.

## Instalação
1. Fecha Godot e servidor. Faz backup da SQLite centralizada, normalmente em `C:\Projects\TronoFragmentado\data\characters.sqlite3`.
2. Extrai o ZIP numa pasta nova. Não copies nem substituas a SQLite.
3. Inicia o servidor em `mvp/server`: `python -m uvicorn main:app --host 127.0.0.1 --port 8000`.
4. Abre `mvp/client/project.godot` no Godot 4 e executa F5.

## Testes
- Aproxima-te da rocha junto à vila (mundo 290,368), verifica etiqueta 40%, tecla G, mensagem de sucesso/falha, cooldown 5 minutos.
- Arbusto junto de Tessa (300,255): etiqueta 20%, brilho violeta enquanto disponível, G, cooldown.
- Árvore sul da vila (350,548): 100%, G, madeira.
- Ferreiro a leste de Tessa: E, escolha do menu, compra, venda e receitas por clique.
- Testa falha de crafting e confirmação de consumo; testa poções, espada ancestral, drops e texto de loot.
- Reinicia o servidor e confirma que a SQLite mantém inventário, missões e cooldowns.

## Validação
A sintaxe Python foi verificada e o ZIP foi testado. O Godot não está disponível neste ambiente, por isso as novas interfaces GDScript ainda precisam de validação no teu computador.
