# Sincronizar código local com o GitHub (MVP 1.0.4.10)

O GitHub contém documentação recente, mas o código de `client/` e `server/` está desatualizado. **Não execute `git pull` sobre o jogo em execução nem envie ficheiros SQLite.**

## Procedimento seguro

1. Faça backup de `server/*.sqlite3` e da pasta `server/backups`.
2. Extraia o ZIP **MVP 1.0.4.10** numa pasta separada.
3. No PowerShell, abra a pasta `mvp` extraída e execute `./SINCRONIZAR_GITHUB.ps1`.
4. O script cria um clone novo, copia somente `client/`, `server/` e `docs/` excluindo bases de dados, caches e segredos, e mostra o `git status`.
5. Confirme a publicação apenas depois de rever os ficheiros. O script faz commit e push para `main`.

## Verificação

Após o push, confirme no GitHub os conteúdos de `client/scripts/main.gd` e `server/main.py` e teste a versão local. **A publicação deste guia não significa que o código já foi sincronizado.**

## Próxima etapa

MVP 1.0.5: evolução incremental da Cripta do Sino Partido para exploração em tempo real, sem perder o modo atual nem o progresso persistido.
