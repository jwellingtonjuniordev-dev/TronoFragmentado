# MVP 0.6.3.1 — Correções da floresta

## Correções
- Perseguição automática do jogador: escolhe um ponto de aproximação acessível por A* em torno do alvo, em vez de tentar atravessar a árvore. Quando não existe percurso, interrompe a perseguição.
- Monstros: caminho A* calculado no servidor e atualizado de forma limitada, com pausa quando bloqueados, em vez de tentativas contínuas de desvio contra obstáculos.
- Lobos: spritesheet com passadas alternadas nas pernas, nos três frames de caminhada.
- Placas: desenhadas acima das copas das árvores, com maior contraste; árvores próximas reposicionadas tanto no cliente como no servidor.
- Portal/ruínas: arco de pedra, ameias, musgo e brasão decorativos.

## Instalação
1. Para o Godot e o servidor.
2. Faz cópia de segurança da base SQLite centralizada. **Não substituas a base de dados.**
3. Extrai o ZIP numa pasta nova.
4. Inicia o servidor em `mvp/server`: `python -m uvicorn main:app --host 127.0.0.1 --port 8000`.
5. Abre `mvp/client/project.godot` no Godot e executa F5.

## Testes de regressão
- Aproxima um lobo que esteja atrás de uma árvore, primeiro com T ligado e depois com ataque manual.
- Observa se o monstro contorna árvores sem oscilar indefinidamente.
- Verifica o movimento alternado das patas dos lobos em deslocação.
- Confirma que as placas estão legíveis e que o portal de pedra aparece na zona das ruínas (sudeste).
- Testa movimento por clique, inventário, combate, nível e ouro.

## Nota técnica
A lógica de combate e o servidor continuam autoritativos. Os caminhos do cliente e do servidor são calculados separadamente, com células de tamanhos diferentes. É necessária validação no Godot e em execução real do servidor. Não foram adicionados novos itens nem alterado o esquema SQLite.
