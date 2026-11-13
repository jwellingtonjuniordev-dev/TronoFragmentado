# Roteiro de testes — MVP 1.0.1

1. Abrir servidor e cliente sem erros.
2. Carregar personagem antigo com **N**; confirmar inventário, ouro, XP e talentos.
3. Com `guardian_quest = completed`, falar com Tessa (**E**) para aceitar *Ecos da Cripta*.
4. Viajar para a região do portal antigo a sudeste das ruínas, perto de `(1500,1040)`, e usar **E**.
5. Confirmar mudança do objetivo no diário (**Q**) para eliminar três saqueadores.
6. Derrotar três saqueadores; confirmar contagem e aviso de conclusão.
7. Voltar a Tessa e receber 400 XP, 300 ouro e 2 fragmentos antigos.
8. Falar novamente com Tessa e confirmar que não é possível repetir a recompensa.
9. Reiniciar servidor e cliente; confirmar estado `completed` persistente.
10. Confirmar ataque por clique, efeitos de estado e pulso do Guardião.

Verificações automáticas realizadas nesta entrega: `py_compile` no servidor e teste de integridade do ZIP. A execução Godot depende de validação local.
