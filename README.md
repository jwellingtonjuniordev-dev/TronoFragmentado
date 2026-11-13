# Crónicas do Trono Fragmentado

**MMORPG original de fantasia medieval em desenvolvimento**, num universo de reinos fragmentados, alianças instáveis, ruínas ancestrais e a ameaça da Fenda. O projeto combina exploração, combate em tempo real, classes, talentos, profissões, crafting, missões e batalhas contra chefes, com apresentação 2.5D em pixel art detalhado.

> **Estado atual:** protótipo jogável MVP 1.0.1; não é ainda um MMORPG completo.

## Tecnologias
- Cliente: Godot 4 / GDScript
- Servidor: Python / FastAPI / WebSocket
- Persistência: SQLite
- Modelo: combate e recompensas validados pelo servidor

## Funcionalidades implementadas
- WASD, movimento e ataque por clique, pathfinding e combate automático
- Guerreiro, Mago e Arqueiro, com habilidades, talentos e efeitos de estado
- Lobos, saqueadores e Guardião das Ruínas com fases e ataques telegrafados
- Missões com Tessa, exploração, baús, loot, ouro e XP
- Inventário, equipamentos, crafting, encantamentos, profissões e recolha
- MVP 1.0.1: missão introdutória **Ecos da Cripta do Sino Partido**, com investigação e progresso persistente

## Executar localmente
1. Instala Python 3.11+ e Godot 4.
2. Na pasta `server`, executa `python -m pip install -r requirements.txt` e `python -m uvicorn main:app --host 127.0.0.1 --port 8000`.
3. Abre `client/project.godot` no Godot e inicia o jogo.
4. Teclas: **N** para carregar personagem, **E** para interagir, **Q** para diário.

**Importante:** faz backup da SQLite antes de atualizar; não publiques dados reais nem credenciais.

## Documentação
A distribuição do projeto contém `docs/INSTALACAO.md`, `docs/ARQUITETURA.md`, `docs/HISTORICO.md`, `docs/ROADMAP.md` e `docs/TESTES.md`.

## Próximos passos
Cripta do Sino Partido como dungeon instanciada, campanha de Valedouro, grupos, novas regiões, classes avançadas e preparação de infraestrutura segura para multiplayer.

**Criador:** Wellington Júnior.
