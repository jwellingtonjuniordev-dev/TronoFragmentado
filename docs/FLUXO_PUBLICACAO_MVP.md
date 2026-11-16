# Fluxo de publicação de cada MVP

1. Implementar e validar a nova versão localmente.
2. Criar ZIP com `client/`, `server/`, `docs/` e os scripts `SINCRONIZAR_GITHUB.bat` / `.ps1`.
3. Testar no Godot e obter aprovação.
4. Executar `SINCRONIZAR_GITHUB.bat` na pasta `mvp` extraída. O script clona a branch `main`, copia as pastas de código e documentação, exclui bases de dados e segredos, mostra o diff e solicita confirmação antes do push.
5. Confirmar no GitHub o commit e os ficheiros atualizados. Nunca afirmar que o código foi publicado antes desta confirmação.

**Estado:** MVP 1.0.5.7 aprovado; publicação do código ainda pendente de execução do sincronizador. Não incluir SQLite, `.env` nem dados dos personagens.
