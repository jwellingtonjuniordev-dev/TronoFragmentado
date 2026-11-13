# Crónicas do Trono Fragmentado — MVP 0.5.2

Atualização incremental do protótipo 0.5.1, preservando os sprites, o inventário, as quests e o SQLite.

## Novidades
- Troncos de oito árvores bloqueiam jogadores e monstros (colisões calculadas no servidor).
- Copas não bloqueiam passagem: são ordenadas visualmente pelo eixo Y com jogadores, NPCs e monstros.
- Deslizamento por obstáculos, com tentativas simples de desvio na perseguição dos monstros.
- O mapa e os sprites existentes permanecem; este pacote é uma melhoria funcional e de profundidade, não o tileset ilustrado final.

## Instalação segura
1. Fecha Godot e servidor. Guarda uma cópia do projeto anterior.
2. Extrai este ZIP para uma pasta nova.
3. Copia **apenas** `characters.sqlite3` do servidor anterior para `mvp/server/` deste pacote. Não substituas o código novo por ficheiros antigos.
4. Na pasta `mvp/server`: `python -m pip install -r requirements.txt` e `python -m uvicorn main:app --host 127.0.0.1 --port 8000`.
5. Importa `mvp/client/project.godot` no Godot 4 Standard e executa F5.
6. Se o nome não for carregado automaticamente, prime N e introduz o nome anterior.

## Testes de aceitação
- Tenta atravessar um tronco: o personagem deve parar ou deslizar lateralmente.
- Passa perto da copa: a imagem da árvore deve ficar à frente do personagem quando ele estiver atrás do tronco.
- Contorna uma árvore e derrota um lobo.
- Verifica compra, poção e quest; reinicia o servidor e confirma o progresso.

## Limitações conhecidas
A IA faz desvios locais, mas pode ficar presa em percursos complexos. Pathfinding com NavigationServer2D/A* ou navmesh no servidor fica para uma etapa posterior. A colisão atual é circular no tronco e os restantes objetos decorativos não são todos sólidos. Os gráficos continuam provisórios.
