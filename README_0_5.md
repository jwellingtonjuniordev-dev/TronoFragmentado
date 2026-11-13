# Crónicas do Trono Fragmentado — MVP 0.5 (primeira passagem visual)

## O que muda
- Cenário redesenhado em Godot com mosaico losangular 64x32, estradas em pedra, árvores e casas com telhados e fachadas detalhadas.
- HUD com barras de vida e XP, informações de nível/ouro e atalhos.
- **Todos os comandos, o protocolo WebSocket e a persistência do MVP 0.4.2 são mantidos.**
- A geometria de colisão e as posições dos monstros/NPC continuam as mesmas.

## Instalação
1. **Faça backup da pasta `server`, especialmente de `characters.sqlite3`.**
2. Extraia o ZIP para uma pasta nova.
3. Para preservar personagens anteriores, copie `characters.sqlite3` da instalação 0.4.2 para `mvp/server/` nesta versão.
4. No terminal em `mvp/server`, execute `python -m pip install -r requirements.txt` e `python -m uvicorn main:app --host 127.0.0.1 --port 8000`.
5. Importe `mvp/client/project.godot` no Godot 4 Standard e execute com F5.
6. Caso o nome não carregue automaticamente, pressione N e introduza o mesmo nome do personagem.

## Limites desta entrega
Esta é a **primeira passagem de direção visual**, ainda não uma arte final 2.5D. O mosaico isométrico é decorativo, enquanto a movimentação e as colisões continuam em coordenadas 2D; sprites 8-direções e profundidade real por ordenação Y virão na próxima passagem.

## Checklist
- Movimento WASD, colisões com casas e interação com Tessa
- Combate, loot, inventário, compra/venda, poções e equipamentos
- Reinício do cliente e servidor com personagem preservado
- Verificar legibilidade do HUD e dos caminhos
