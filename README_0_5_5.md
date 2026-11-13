# MVP 0.5.5 — Movimentação com clique direito e A*

## Novidades
- Clique direito no terreno para caminhar usando A* em grade de 16 px.
- O percurso evita casas, cercas, troncos, rochas, arbustos, barris e Tessa.
- WASD interrompe a navegação por clique; é possível clicar novamente para definir novo destino.
- Marcadores dourados indicam o percurso.
- O servidor continua a validar movimento e colisões; monstros e outros jogadores são obstáculos dinâmicos e podem exigir recálculo.
- Não foi ativado combate automático nesta versão.

## Instalação
1. Pare o servidor anterior e feche o Godot.
2. Faça cópia de segurança de `C:\Projects\TronoFragmentado\data\characters.sqlite3`.
3. Extraia este ZIP numa pasta nova e abra `mvp/client/project.godot`.
4. No PowerShell em `mvp/server`, execute `python -m uvicorn main:app --host 127.0.0.1 --port 8000`.
5. Execute F5 no Godot e teste o clique direito em diferentes pontos.

## Testes recomendados
- Clique atrás de uma casa ou cerca: personagem deve contornar.
- Clique em rocha: deve parar numa célula livre próxima.
- Use WASD durante a navegação: caminho deve ser cancelado.
- Abra inventário, loja e diário: cliques nos painéis não devem mover o herói.
- Confirme progresso do personagem e persistência após reiniciar o servidor.

## Nota
A* planeia sobre obstáculos fixos. Entidades móveis são validadas pelo servidor; se bloquearem o caminho, o cliente tenta recalcular, mas não garante a rota globalmente ótima com obstáculos móveis.
