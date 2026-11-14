# MVP 1.0.4.2 — Correção de falha do servidor

## Diagnóstico
Após a ligação WebSocket, o servidor lançava `UnboundLocalError: cannot access local variable 'distance' where it is not associated with a value` em `server/main.py`, no processamento do ataque normal.

## Causa
No mesmo handler WebSocket, o cálculo de distância da dungeon atribuía a variável local `distance`. Isso ocultava a função global `distance(p,m)` utilizada no combate do mundo, mesmo antes da atribuição ser executada.

## Correção
Renomeada a variável da dungeon para `dungeon_distance`, incluindo a comparação de alcance e o aviso. Não altera dano, atributos, persistência ou regras da dungeon.

## Validação
Sintaxe Python compilada e ZIP íntegro. Execução em Godot/Windows pendente de teste local.

## Publicação
O código corrigido foi entregue no ZIP do MVP 1.0.4.2; a sincronização integral do código no GitHub ainda não está confirmada.
