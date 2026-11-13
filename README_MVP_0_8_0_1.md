# MVP 0.8.0.1 — Fragmentos de metal antigo

## Alterações
- Recolher uma rocha concede o material habitual (minério de ferro ou 3 fragmentos de rocha).
- Em cada recolha válida de rocha, existe uma oportunidade **independente de 30%** para obter **+1 Fragmento de metal antigo**. Não substitui o material habitual.
- A lógica é processada no servidor e o item é persistido no inventário.

## Adicionar 6 fragmentos ao John (uma única vez)
1. **Fecha o servidor antes de executar.**
2. Extrai o pacote na pasta `C:\Projects\TronoFragmentado\MVP_0_8_0_1` (ou outra dentro de `TronoFragmentado`).
3. No PowerShell, entra na pasta `mvp` e executa: `python ADICIONAR_6_FRAGMENTOS_JOHN.py`.
4. Confirma o caminho da SQLite apresentado. Escreve `SIM` apenas se for a base correta.
5. O script cria `characters_backup_antes_6_fragmentos.sqlite3` e adiciona exatamente 6 ao John.
6. Reinicia o servidor e o Godot. **Não repitas o script**, senão adicionará mais 6.

Se o servidor estiver configurado com `TRONO_DATA_DIR`, executa o script com a mesma variável de ambiente.

A SQLite do utilizador não está incluída no pacote; nenhum outro item, nível, ouro ou equipamento é alterado pelo script.
