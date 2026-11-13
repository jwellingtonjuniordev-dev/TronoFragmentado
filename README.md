# Crónicas do Trono Fragmentado

**MMORPG de fantasia medieval em desenvolvimento**, com um mundo original marcado por reinos fragmentados, alianças instáveis, ruínas ancestrais e a ameaça da Fenda. O projeto combina exploração, combate em tempo real, progressão de personagens, profissões, crafting, missões e batalhas contra chefes, numa apresentação 2.5D de pixel art detalhado inspirada na legibilidade dos RPGs clássicos.

> Estado: protótipo jogável **MVP 1.0.1**; não é um MMORPG completo nem um lançamento de produção.

## Tecnologias

- **Cliente:** Godot 4 / GDScript.
- **Servidor:** Python / FastAPI / WebSocket.
- **Persistência:** SQLite para personagens e estado local do mundo.
- **Arquitetura:** servidor autoritativo para combate, movimento e recompensas.

## Funcionalidades atuais

- Movimento WASD, navegação por clique, seleção de alvos, perseguição e combate automático.
- Três classes jogáveis: Guerreiro, Mago e Arqueiro, com habilidades, talentos e efeitos de estado.
- Lobos, saqueadores e Guardião das Ruínas com fases, resistências e ataques telegrafados.
- Missões com Tessa, exploração, baús, loot, experiência e progressão persistente.
- Inventário, equipamento, forja, encantamentos, recolha de recursos e profissões.
- **MVP 1.0.1:** início da linha narrativa da *Cripta do Sino Partido*, com investigação, caça e recompensa persistente.

## Executar localmente

1. Instala **Python 3.11+** e **Godot 4**.
2. No terminal, dentro de `server/`, instala as dependências do projeto (consulta `requirements.txt`).
3. Inicia o servidor conforme `docs/INSTALACAO.md`.
4. Abre `client/project.godot` no Godot e executa o projeto.
5. Dentro do jogo, usa **N** para carregar o personagem pelo nome; **E** para interagir e **Q** para abrir o diário de missões.

> **Dados pessoais:** a pasta de dados e ficheiros SQLite são excluídos do Git. Faz backup antes de atualizar.

## Documentação

- [`docs/INSTALACAO.md`](docs/INSTALACAO.md): preparação e execução local.
- [`docs/ARQUITETURA.md`](docs/ARQUITETURA.md): responsabilidades do cliente, servidor e persistência.
- [`docs/HISTORICO.md`](docs/HISTORICO.md): evolução e alterações.
- [`docs/ROADMAP.md`](docs/ROADMAP.md): etapas futuras alinhadas com a Bíblia do Mundo.
- [`docs/TESTES.md`](docs/TESTES.md): roteiro de validação.

## Universo e visão

A campanha completa e as regiões futuras estão descritas nos documentos originais de conceção. O objetivo é evoluir o protótipo de Valedouro até um mundo persistente com dungeons, facções, classes avançadas e uma narrativa sobre os fragmentos do trono.

**Desenvolvimento:** projeto original de Wellington Júnior. Código em evolução; funcionalidades podem mudar.
