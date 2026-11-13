# MVP 0.6.7.1 — Guardião e spawns seguros

## Correções
- Guardião passa a nascer numa área livre a norte das ruínas, fora do portal e das árvores.
- Todos os monstros recebem posições aleatórias próximas das respetivas zonas de origem; cada posição é validada pelo servidor contra árvores, casas, rochas, cercas, arbustos, barris, NPC, jogadores e outros monstros.
- O respawn também escolhe uma nova posição válida, mantendo a área de origem de cada monstro.
- Ajustado o raio de ataque do Guardião e a aproximação do A* para reduzir casos em que ele fica fora do alcance.
- O nome completo do Guardião aparece sobre a vegetação e não é cortado.
- Banner ao entrar no jogo com o Guardião ativo e sempre que ele reaparece (após 3 minutos).
- Selo das Ruínas identificado como relíquia de coleção. Ainda não pode ser usado, vendido ou convertido; a sua função futura será implementada noutra versão.

## Instalação
1. Fecha o servidor e o Godot.
2. Faz backup de `C:\Projects\TronoFragmentado\data\characters.sqlite3`.
3. Extrai o ZIP para uma pasta nova.
4. Inicia o servidor em `mvp/server`: `python -m uvicorn main:app --host 127.0.0.1 --port 8000`.
5. Abre `mvp/client/project.godot` no Godot e executa com F5.

## Testes
- Visita as ruínas e aproxima-te do Guardião: deve perseguir e atacar quando estiver ao alcance.
- Confirma que o nome completo aparece e o banner é visível.
- Derrota-o: 350 XP, 250 ouro e 1 Selo das Ruínas; reaparece aproximadamente 3 minutos depois.
- Reinicia o servidor algumas vezes: monstros não devem aparecer dentro de obstáculos.
- Verifica baús (respawn de 5 min), missões, inventário, colisões e progresso do personagem.

Nota: o Godot não está instalado no ambiente de preparação. A sintaxe do servidor e a integridade do ZIP foram verificadas, mas é necessário testar o cliente no teu PC.
