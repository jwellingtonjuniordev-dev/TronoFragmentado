# MVP 0.6.9 — O Selo das Ruínas

Nova missão de Tessa, disponível após a missão de exploração da floresta estar concluída.

1. Conversa com Tessa (E) para aceitar.
2. Derrota o Guardião das Ruínas **depois de aceitar** a missão.
3. Recolhe o Selo das Ruínas e regressa a Tessa.
4. Entrega um Selo para receber 450 XP, 500 ouro e 5 poções pequenas.

O servidor confirma a morte do Guardião, a posse do Selo e a distância até Tessa. A entrega remove exatamente um Selo e a recompensa é atribuída uma única vez. O estado da missão fica no JSON do personagem na SQLite centralizada. Selos já existentes não dispensam derrotar o Guardião depois de aceitar a missão.

O diário (Q) apresenta a terceira missão. Os baús, combate, A*, cura visual, Pulso das Ruínas e inventário não foram modificados.

Instalação: fecha o jogo e o servidor, faz backup da SQLite, extrai numa pasta nova, inicia em `mvp/server` com `python -m uvicorn main:app --host 127.0.0.1 --port 8000` e abre `mvp/client/project.godot` no Godot 4.

Não inclui ficheiros SQLite. A sintaxe Python e integridade do ZIP foram verificadas; a execução no Godot ainda precisa de validação.
