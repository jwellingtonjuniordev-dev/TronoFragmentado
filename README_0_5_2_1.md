# MVP 0.5.2.1 — Colisões avançadas

Correção de colisões de troncos e inclusão de rochas, arbustos densos, barris, cercas e colisões entre jogador, monstros e NPC Tessa.

## Instalação
1. Guarda uma cópia da pasta anterior e da base `characters.sqlite3`.
2. Extrai o ZIP numa nova pasta.
3. Copia o `characters.sqlite3` anterior para `mvp/server/` (não o substituas por outro).
4. Na pasta `mvp/server`, executa `python -m pip install -r requirements.txt` e `python -m uvicorn main:app --host 127.0.0.1 --port 8000`.
5. Importa `mvp/client/project.godot` no Godot 4 e inicia com F5.

## Testes
- Encosta a um tronco de árvore, rocha, arbusto denso, barril e cerca: não deve atravessar.
- Caminha tangencialmente: deve deslizar pela borda.
- Encosta a Tessa, lobos e saqueador: não deve atravessar.
- Abre uma segunda instância do jogo: jogadores não devem ocupar o mesmo espaço.
- Confirma combate, loja, quests, inventário e persistência após reiniciar.

## Limitações
- IA dos monstros usa desvios locais; ainda não há A* / navegação por caminhos.
- A colisão é circular para entidades e obstáculos naturais; o servidor é autoritativo.
- Os recursos gráficos continuam provisórios.
