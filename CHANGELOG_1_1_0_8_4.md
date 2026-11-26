# MVP 1.1.0.8.4 — Selecao de herois por Z

- Tecla Z abre/fecha a lista dos herois existentes.
- Clique no heroi solicita `select_hero` ao servidor e carrega o perfil guardado.
- Confirmacao `hero_selected` atualiza o heroi ativo no cliente e fecha o menu.
- Tecla N permanece exclusiva para criar novos personagens.
- Selecionar nome inexistente nao cria heroi.
- Consulta de nomes existentes ignora diferencas de maiusculas/minusculas.
- Mantidos dados SQLite, recursos, personagens, cenas e demais sistemas.

## Testes
1. Iniciar servidor; abrir jogo e pressionar Z.
2. Selecionar John e verificar nome, classe, nivel, inventario e posicao.
3. Pressionar Z novamente, selecionar outro heroi e verificar a troca.
4. Pressionar N e confirmar que apenas o formulario de criacao abre.
5. Reiniciar o jogo e confirmar que nenhum heroi e selecionado automaticamente.
