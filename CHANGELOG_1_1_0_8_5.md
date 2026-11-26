# MVP 1.1.0.8.5 — Correção do dropdown de heróis

Base: MVP 1.1.0.8.4.

- `client/scripts/main.gd`: bloqueia a interpretação de eventos do mouse pelo mundo enquanto o seletor de heróis está aberto, sem consumir eventos destinados à GUI.
- `OptionButton` e `PopupMenu` recebem `MOUSE_FILTER_STOP` para que o clique selecione a opção e não provoque movimentação.
- Mantidos Z para abrir/fechar a seleção, N para criação e carregamento via `select_hero` no WebSocket.
- Não alterados servidor, banco de dados, personagens, inventário ou assets.

## Testes
1. Iniciar servidor e cliente; pressionar Z.
2. Clicar no dropdown e confirmar que o herói não se movimenta.
3. Selecionar um herói e verificar nome, classe, nível e inventário.
4. Abrir novamente com Z e trocar de herói.
5. Fechar com Z e confirmar que clique esquerdo volta a mover/atacar.
6. Pressionar N e verificar criação de novo herói.

Teste em Godot ainda necessário.
