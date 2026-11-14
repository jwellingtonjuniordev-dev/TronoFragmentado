# MVP 1.0.3.2 — Heróis independentes e Cripta repetível

- Uma nova identificação reinicializa o perfil antes de criar/carregar outro herói, sem herdar atributos da sessão anterior.
- O perfil anterior é guardado antes da troca de nome.
- A Cripta pode ser repetida após a primeira purificação.
- O prémio único (700 XP, 600 ouro, 3 fragmentos) continua disponível uma única vez por herói.
- A repetição reinicia as salas; o estado de conclusão persistente não é apagado.
- Se sair a meio da repetição, pode retomar na mesma sessão.
- Reiniciar o servidor durante uma repetição reinicia a expedição (não altera a conclusão original).

**Importante:** faz backup da SQLite com o servidor parado antes de atualizar.
**Verificação:** compilação Python e integridade do ZIP; requer teste no Godot.
