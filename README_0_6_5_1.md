# MVP 0.6.5.1 — Correção de cinco avisos do Godot

Esta versão mantém o sistema de três baús com respawn de cinco minutos e toda a lógica do servidor intacta.

Correções no client/scripts/main.gd:
- Variável `sign` renomeada para `region_sign`.
- Variável `seed` renomeada para `terrain_seed`.
- Divisão de índice por 2 convertida em divisão decimal antes de `int`.
- Parâmetro `scale` renomeado para `sprite_scale`.
- Parâmetro não utilizado `outfit` removido da função e de ambas as chamadas.

Não inclui base de dados SQLite. Antes de instalar, faz backup da base de dados centralizada. Fecha o servidor e o Godot, extrai para uma nova pasta, abre o project.godot e executa F5.

Não foi possível executar o Godot neste ambiente; confirma que o separador Depurador > Erros não apresenta os cinco avisos após reiniciar o editor.
