# MVP 0.6.9.6 — Animações de Recolha

Base: ZIP MVP_0_6_9_5 enviado pelo utilizador.

## Novidades
- Corte de madeira: movimento de machado e lascas.
- Mineração: movimento de picareta e partículas de pedra.
- Ervas: pulso luminoso e partículas verdes.
- O servidor envia o evento `gather_result` com o tipo e posição do recurso após aceitar a recolha; o cliente anima sem alterar o cálculo do loot.
- Os textos de recompensa continuam sobre o cenário.

## Preservado
- Taxas de drop, recolha, 40 s de reaparecimento, posições seguras, loja, venda em lotes, receitas, missões, baús, dia/noite e SQLite.

## Instalação
1. Fechar Godot e servidor.
2. Fazer cópia de segurança de `characters.sqlite3` e de qualquer outra SQLite de progresso, caso exista.
3. Extrair numa pasta nova. Não substituir a SQLite centralizada existente.
4. Abrir o projeto `mvp/client/project.godot` no Godot 4 e executar o servidor na pasta `mvp/server`.
5. Testar G em árvores, rochas e ervas, incluindo casos em que o drop falha.

**Nota:** esta versão implementa animações e partículas desenhadas pelo Godot, sem áudio novo. O GDScript não foi compilado pelo Godot neste ambiente; requer validação no PC. A sintaxe Python e o ZIP foram verificados.
