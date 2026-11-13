# MVP 0.9.6 — Efeitos de estado

- Guerreiro (Corte Heroico): atordoa monstros comuns durante 1,3 segundos. O Guardião é imune.
- Mago (Explosão Arcana): aplica queimadura por aproximadamente 3 segundos, com dano periódico calculado pelo servidor.
- Arqueiro (Flecha Precisa): abranda o movimento do alvo para 45% durante 4 segundos.
- Os efeitos aparecem no próprio monstro e terminam automaticamente. O estado não persiste após a morte/respawn.
- Mantidos controlos, talentos, equipamentos e combate por clique.
- Limitação: se a queimadura causar o golpe final, não concede loot/XP adicionais. Evita duplicação de recompensas; corrigir atribuição de crédito num próximo incremento.
- Faça backup da SQLite existente; este ZIP não a inclui.
- Validado: compilação Python e integridade do ZIP. Requer teste no Godot.
