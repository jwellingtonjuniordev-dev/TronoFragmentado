# Correção MVP 1.0.4.1 — Ataque na Cripta

## Problema
O ataque com a tecla 1 não apresentava feedback suficiente quando o herói estava fora do alcance do esqueleto. A leitura das teclas 1 e 2 era distribuída por diferentes condições de mundo e dungeon.

## Alterações
- A leitura das teclas 1, 2 e 3 ocorre uma única vez por frame no cliente.
- O mapa tático mostra **ALCANCE OK** ou **FORA DE ALCANCE**, incluindo a distância Manhattan ao inimigo.
- O servidor devolve mensagem com a distância real quando o ataque é rejeitado.
- O alcance permanece de 2 casas; o dano continua autoritativo no servidor.
- A SQLite e o progresso dos heróis não são modificados.

## Validação
Compilação Python e integridade ZIP verificadas. Godot ainda exige teste local.

## Publicação
A documentação desta correção foi enviada ao GitHub. O pacote de código completo está disponível no ZIP entregue na conversa; a sincronização integral do código no repositório ainda precisa de ser confirmada.
