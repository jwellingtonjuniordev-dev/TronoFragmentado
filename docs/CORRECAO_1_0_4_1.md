# MVP 1.0.4.1 — Correção de ataque na Cripta

- Leitura única das teclas 1, 2 e 3 por frame, evitando conflitos entre o mundo e a dungeon.
- Indicador visual de alcance: verde quando John está a até duas casas (distância Manhattan), laranja quando está longe.
- Mensagem do servidor informa a distância real quando o ataque é rejeitado.
- O dano, a distância de ataque e a progressão permanecem controlados pelo servidor.
- Não altera a SQLite nem as recompensas.

## Teste

Entre na Cripta com K; aproxime-se do esqueleto até aparecer `ALCANCE OK`; pressione 1 e confirme que o HP diminui. Teste as teclas 2 e 3.

A compilação Python e a integridade ZIP foram verificadas; execução no Godot ainda requer validação local.
