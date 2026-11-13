# MVP 0.5.1 — Primeiros sprites animados

Esta versão mantém o servidor Python e a lógica de jogabilidade do MVP 0.5. Acrescenta quatro atlases PNG originais desenhados proceduralmente: herói, Tessa, lobo e saqueador. Cada atlas tem 4 direções x 4 fotogramas. O herói muda a direção conforme a movimentação e alterna os fotogramas enquanto anda; os monstros têm animação visual de repouso provisória. Espada e escudo continuam desenhados por cima do sprite do herói equipado.

**Limitações:** arte ainda provisória; não existem animações de ataque dedicadas nem deteção de direção dos monstros. A aparência é uma melhoria incremental, não a arte ilustrada final da imagem conceptual.

## Instalação segura

1. Fecha Godot e servidor. Faz backup da pasta do projeto anterior e de `server/characters.sqlite3` (caso exista).
2. Extrai este ZIP numa pasta nova.
3. Se o servidor anterior contém o progresso, copia **apenas** `characters.sqlite3` da pasta `server` antiga para a pasta `mvp/server` nova, mantendo o mesmo nome e sem criar outro ficheiro vazio.
4. Dentro de `mvp/server`, executa `python -m pip install -r requirements.txt` e depois `python -m uvicorn main:app --host 127.0.0.1 --port 8000`.
5. Importa `mvp/client/project.godot` no Godot 4 Standard e executa com F5. Se não recuperar o herói automaticamente, pressiona N e escreve o nome exato que usavas.

## Testes

- WASD: sprite muda de orientação e anima ao andar.
- Tessa, lobos e saqueador: sprites visíveis.
- Equipamentos: espada e escudo continuam visíveis ao equipar.
- Combate, quests, loja, inventário e poções: comportamento inalterado.
- Reinício: os dados do herói permanecem no SQLite.

**Segurança:** protótipo local, não publicar o servidor na Internet. Ainda não houve teste de execução dentro do editor Godot neste ambiente.
