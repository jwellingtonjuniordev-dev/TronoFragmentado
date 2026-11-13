# MVP 0.8.0 — Equipamentos individuais e encantamentos

## Instalação segura
1. Encerra o Godot e o servidor.
2. Faz uma cópia do ficheiro `characters.sqlite3` da tua instalação ativa (e, se existirem, `-wal` e `-shm`).
3. Extrai este pacote numa pasta nova. Não substituas a base de dados.
4. Inicia o servidor com a configuração/caminho de dados persistentes que já utilizas; verifica `DB_PATH` em `server/main.py`.
5. Abre `client/project.godot` no Godot e inicia o jogo.

## Novidades
- Cada equipamento da mochila e cada equipamento vestido recebe um ID único.
- A migração dos equipamentos antigos acontece uma vez ao carregar a personagem, preservando os níveis de melhoria existentes por modelo.
- Melhoria +1 a +10 passa a pertencer à unidade equipada, não ao modelo.
- Encantamentos: Fúria (+3 ATQ, 65%), Proteção (+3 DEF, 50%), Rúnico (+5 ATQ e +5 DEF, 20%). Um por item.
- Custo de encantamento: 900 ouro, 2 barras de ferro e 1 fragmento de metal antigo. Falha consome recursos, não destrói o equipamento.
- No Ferreiro, `U` abre melhorias. Clica **uma vez** no espaço do equipamento para o selecionar e depois num dos três botões de encantamento. Clicar novamente no mesmo espaço confirma a melhoria +1.
- O servidor valida recursos, distância e efeitos.

## Limitações conhecidas
- A mochila continua a agrupar visualmente cópias do mesmo modelo. Ao equipar ou vender um lote, o servidor escolhe a primeira unidade desse modelo. Uma futura versão deve permitir escolher explicitamente cada ID.
- A comparação de equipamentos ainda apresenta os atributos base do modelo, não o total incluindo encantamentos.
- Esta versão não foi executada no Godot neste ambiente: valida a importação e os testes no cliente antes de a usar como instalação principal.
