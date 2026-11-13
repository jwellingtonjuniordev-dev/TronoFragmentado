# MVP 0.6.9.4 — Recolha, forja e ciclo dia/noite

## Implementado
- 40 segundos de recarga por ponto de recolha, por personagem, persistidos em SQLite.
- Indicador [G] desaparece enquanto o ponto está indisponível; não aparece cronómetro.
- 37 árvores, 6 rochas e 6 arbustos do mapa identificados como candidatos de recolha (49 pontos seguros). Não são usados pontos dentro de casas, ruínas nem próximos de baús.
- A cada recolha, o servidor escolhe aleatoriamente outro local seguro do mesmo tipo para o reaparecimento. O ponto reaparece passados 40 segundos. Os elementos estáticos do cenário mantêm-se visíveis e com colisão; o que desaparece é o marcador de recurso. Esta versão NÃO remove fisicamente as árvores/rochas do cenário.
- Árvore: 3 Fragmentos de madeira garantidos.
- Rocha: 70% de obter 1 Minério de ferro; em caso de falha, 3 Fragmentos de rocha garantidos.
- Arbusto: 20% de obter 1 Erva rara; sem item quando falha.
- O servidor envia ao cliente as posições disponíveis a cada 2 segundos e após ações.
- Ferreiro compra materiais comuns, mas não materiais raros, relíquias nem equipamentos especiais.
- Novas receitas: 6 Fragmentos de madeira -> Tábua de madeira (80%); 6 Fragmentos de rocha -> Bloco de pedra (80%); 2 Tábuas + 3 Peles -> Escudo reforçado +6 defesa (65%); 2 Blocos + 1 Barra de ferro -> Armadura de pedra +10 defesa (40%). A receita lendária passa a usar 12 Fragmentos de madeira, em vez de Madeira antiga.
- Menu da forja: roda do rato para ver as nove receitas.
- Ciclo alternado: 1 hora real de dia e 1 hora real de noite, calculado a partir do relógio do sistema. Noite escurece o mapa e mostra focos de luz de lanternas de casas/ruas e candeeiro do herói (raio visual de 90 px). Os focos são efeitos visuais aproximados, não iluminação 2D fisicamente correta.

## Instalação
1. Fechar servidor e Godot. Fazer cópia da base SQLite centralizada, normalmente `C:\Projects\TronoFragmentado\data\characters.sqlite3`.
2. Extrair o ZIP para uma pasta nova. Não substituir a base de dados.
3. Iniciar em `mvp/server`: `python -m uvicorn main:app --host 127.0.0.1 --port 8000`.
4. Abrir `mvp/client/project.godot` no Godot 4 e executar F5.
5. Aproximar-se de árvores, rochas e arbustos identificados e pressionar G. Aproximar-se do Ferreiro e pressionar E para loja/forja.

## Testes
- Recolher árvore, confirmar 3 fragmentos, marcador desaparece e reaparece em local válido após ~40s.
- Recolher rochas e confirmar taxa de minério 70% e alternativa de 3 fragmentos.
- Testar erva rara (20%) e deslocação aleatória do ponto.
- Vender materiais comuns; confirmar que raros não são vendidos.
- Criar tábua, bloco, escudo reforçado e armadura de pedra; equipar e validar defesa.
- Testar ciclo dia/noite (depende da hora do sistema), iluminação, combate, NPCs, A*, baús, missões e persistência.

## Validação
Sintaxe e importação Python verificadas; integridade do ZIP verificada. Godot não foi executado neste ambiente; confirmar o parser GDScript e a aparência visual no PC.
