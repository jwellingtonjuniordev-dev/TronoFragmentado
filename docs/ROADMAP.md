# Roadmap — Crónicas do Trono Fragmentado

## Estado atual
Protótipo jogável em Valedouro, com cliente Godot, servidor Python, persistência SQLite e campanha inicial. **A Cripta do Sino Partido ainda não é uma dungeon instanciada**; o MVP 1.0.1 introduz a missão que prepara a entrada.

## Próximas etapas
1. **Cripta do Sino Partido:** mapa interior próprio, entrada/saída, salas, objetivos, encontros e chefe final; instanciamento seguro no servidor.
2. **Campanha de Valedouro:** expandir Q001–Q003 e personagens Tessa, Halen e Elira, alinhados com os documentos narrativos.
3. **Sistemas de grupo:** convites, partilha de objetivos, recompensas e instâncias cooperativas.
4. **Mundo e facções:** novas regiões, reputação, escolhas e NPCs da Bíblia do Mundo.
5. **Progressão:** classes avançadas, equipamentos, profissões, economia e habilidades adicionais.
6. **Infraestrutura:** autenticação, separação em módulos, migrações, testes automatizados, métricas e proteção de rede.
7. **Polimento:** animações, interface, áudio original, acessibilidade, balanceamento e otimização.

## Critérios de qualidade
- Não perder progresso do jogador durante atualizações.
- Recompensas concedidas pelo servidor, no máximo uma vez por objetivo.
- Cliente e servidor testados em conjunto antes de marcar uma versão como aprovada.
- Documentar limitações e funcionalidades ainda não implementadas.

**Após 1.0.2:** transformar o painel tático em mapa interior navegável com inimigos, colisões e combate em tempo real.
