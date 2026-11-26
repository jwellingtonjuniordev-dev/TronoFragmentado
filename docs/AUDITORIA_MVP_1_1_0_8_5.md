# Auditoria e plano de estabilização — MVP 1.1.0.8.5

Data: 2026-11-26. Base examinada: branch `atualizacao/mvp-1.1.0.8.5`, `server/main.py`, `server/requirements.txt`, `README.md` e plano existente.

## Diagnóstico confirmado pelo código
- Cliente Godot/GDScript; servidor FastAPI/WebSocket; SQLite.
- O servidor expõe `GET /health` e `WS /ws`; o endpoint de saúde reporta a versão interna `0.4`, diferente da versão do projeto `1.1.0.8.5`.
- No WebSocket, o cliente pode enviar `select_hero` com um nome. O servidor consulta `load_character(name)` sem autenticar uma conta proprietária. **Não disponibilizar esse serviço na Internet** antes de corrigir a autorização por personagem.
- O projeto contém classes Guerreiro, Mago e Arqueiro, Tessa, forja, banco, recursos, cripta e guardiões. A presença no código não substitui testes funcionais.
- O prompt narrativo original integral não estava acessível nesta auditoria; os documentos de lore existentes continuam sendo a fonte canônica até revisão.

## Critérios de aceite do MVP mínimo
1. Servidor inicia sem sobrescrever os dados SQLite existentes; backup restaurável verificado.
2. Cliente Godot conecta localmente, cria ou seleciona personagem e mantém os atributos após reinício.
3. Um mapa navegável, colisões e movimento consistentes; cliques na UI não acionam movimento.
4. Combate básico com validação de alcance, cooldown e dano no servidor.
5. NPC Tessa oferece quest com progressão e recompensa persistentes.
6. Regressões executadas em Windows/Godot; testes automáticos e evidências registradas.

## Ordem das próximas rodadas
| Prioridade | Frente | Entregável | Critério de conclusão | Risco |
|---|---|---|---|---|
| P0 | Segurança, servidor, banco | Autenticação por conta e autorização de personagens; migração SQLite com backup | Não é possível selecionar personagem de outra conta; testes positivos/negativos | Migração de saves |
| P0 | Cliente, UI, combate | Correção do seletor Z, smoke test e testes de regras do servidor | UI não transmite clique ao mundo; combate validado | Regressões de input |
| P1 | Multiplayer/netcode | Sincronização de dois clientes, rate limiting e desconexão segura | Duas sessões independentes sem perda de estado | Dessincronização |
| P1 | Quests, lore | Vertical slice de Valedouro com Tessa e cripta | Quest concluível sem intervenção manual; lore revisado | Inconsistência narrativa |
| P1 | Arte e áudio | Sprites transparentes, alinhados; SFX de combate/UI | Teste visual de 4 direções e volume ajustável | Custo de produção |
| P2 | Classes, facções e casas | Design original de três classes e facções políticas | Identidade, habilidades e conflitos documentados | Escopo e balanceamento |
| P2 | Mapas e cidades | Uma região adicional conectada a Valedouro | Transição e spawn persistentes | Performance |
| P2 | Economia | Preços, sinks de ouro e limites de crafting | Sem duplicação de itens e inflação descontrolada em simulações | Exploits |
| P3 | Monetização | Política de monetização cosmética, sem pay-to-win | Revisão jurídica, de plataforma e UX antes de cobrança | Legal e reputacional |

## Segurança: ações obrigatórias antes de produção
- Identidade de conta com credenciais armazenadas como hashes robustos; nunca aceitar o nome do herói como prova de posse.
- Associação `account_id -> character_id` no banco; validar posse em toda seleção, alteração, troca e salvamento.
- Validar mensagens WebSocket com limites de tamanho, tipo, frequência, estado, alcance, cooldown e recursos disponíveis.
- Executar testes de concorrência, reconexão, duplicação de itens e corrupção/recuperação de SQLite.
- Não introduzir pagamentos nem acesso público até concluir auditoria de autenticação.

## Matriz de validação
- **Código inspecionado:** endpoints de saúde e WebSocket; seleção por nome; dependências FastAPI/Uvicorn.
- **Não verificado nesta rodada:** execução do Godot, jogabilidade, dois clientes simultâneos, testes de carga, balanceamento numérico e segurança ponta a ponta.
- **Risco conhecido:** não alterar o esquema SQLite nem reescrever os sistemas existentes sem teste de migração e cópia de segurança.

## Referências internas
- `README.md`
- `PLANO_DE_DESENVOLVIMENTO.md`
- `docs/ARQUITETURA.md`
- `docs/TESTES.md`
