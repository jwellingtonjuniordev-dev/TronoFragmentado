# Crónicas do Trono Fragmentado

**MMORPG de fantasia medieval em desenvolvimento**, com um mundo original marcado por reinos fragmentados, alianças instáveis, ruínas ancestrais e a ameaça da Fenda. O projeto combina exploração, combate em tempo real, progressão de personagens, profissões, crafting, missões e batalhas contra chefes, numa apresentação 2.5D de pixel art detalhado inspirada na legibilidade dos RPGs clássicos.

> Estado: protótipo jogável **MVP 1.1.0.8.5** (branch de desenvolvimento; testes de regressão ainda pendentes); não é um MMORPG completo nem um lançamento de produção.

## Tecnologias

- **Cliente:** Godot 4.7 / GDScript.
- **Servidor:** Python / FastAPI / WebSocket.
- **Persistência:** SQLite para personagens e estado local do mundo.
- **Arquitetura:** servidor autoritativo para combate, movimento e recompensas.

## Funcionalidades atuais

- Movimento WASD, navegação por clique, seleção de alvos, perseguição e combate automático.
- Três classes jogáveis: Guerreiro, Mago e Arqueiro, com habilidades, talentos e efeitos de estado.
- Lobos, saqueadores e Guardiões da Tempestade e do Sino Partido, além de Velkran na cripta, com fases, resistências e ataques telegrafados.
- Missões com Tessa, exploração, baús, loot, experiência e progressão persistente.
- Inventário, equipamento, forja, encantamentos, recolha de recursos e profissões.
- **MVP 1.0.1:** início da linha narrativa da *Cripta do Sino Partido*, com investigação, caça e recompensa persistente.

## Executar localmente

1. Instala **Python 3.11+** e **Godot 4.7**.
2. No terminal, dentro de `mvp/server/` (ou `server/` se o repositório já estiver aberto nessa pasta), executa `python -m pip install -r requirements.txt`.
3. Inicia o servidor com `python -m uvicorn main:app --host 127.0.0.1 --port 8000`, na pasta do servidor; consulta também `docs/INSTALACAO.md`.
4. Abre `mvp/client/project.godot` (ou `client/project.godot`, conforme a raiz extraída) no Godot e executa o projeto.
5. Dentro do jogo, usa **Z** para abrir a seleção de heróis existentes, **N** para criar um novo herói, **E** para interagir e **Q** para abrir o diário de missões. A seleção por Z requer validação funcional no Godot (clique no dropdown ainda em teste).

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

## Verificação mínima

Com o servidor local iniciado, executa na raiz do repositório:

```powershell
python -m unittest discover -s tests -p 'test_health.py' -v
```

Este teste verifica apenas `GET /health`; **não valida combate, seleção de heróis ou multiplayer**. Consulta [a auditoria da MVP 1.1.0.8.5](docs/AUDITORIA_MVP_1_1_0_8_5.md) antes de disponibilizar o servidor publicamente. A seleção de personagens por nome ainda não comprova propriedade de conta.
