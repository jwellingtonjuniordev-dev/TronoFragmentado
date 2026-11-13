# Crónicas do Trono Fragmentado — MVP 0.5.3

## Novidades
- Mochila e equipamento em painel medieval (`I`).
- Mercado de Tessa em painel medieval (`M`), com compras 1/2/3, equipamentos 4/5/6 e vendas 7/8.
- Diário de missões (`Q`) e diálogo com Tessa (`E`, fechar com `Esc`).
- Persistência centralizada: no Windows, ao extrair em `C:\Projects\TronoFragmentado\...`, a base ativa fica em `C:\Projects\TronoFragmentado\data\characters.sqlite3`.
- Na primeira execução, se a base central ainda não existir, o servidor **copia** os personagens do SQLite incluído em `mvp/server/characters.sqlite3`, sem o alterar. O ZIP enviado tinha John nível 12, 2358 ouro, e Jonh nível 6.
- Se a base central já existir, **não é substituída**; os personagens dessa base prevalecem. A localização ativa é apresentada no terminal.

## Instalação no Windows
1. Fecha o servidor anterior (`Ctrl+C`) e o jogo.
2. Faz cópia de segurança de `C:\Projects\TronoFragmentado\mvp\server\characters.sqlite3` e, se existir, `C:\Projects\TronoFragmentado\data\characters.sqlite3`.
3. Extrai este ZIP em `C:\Projects\TronoFragmentado\MVP_0_5_3` (podes renomear a pasta extraída).
4. No PowerShell, entra em `...\MVP_0_5_3\mvp\server` e executa `python -m pip install -r requirements.txt` e `python -m uvicorn main:app --host 127.0.0.1 --port 8000`.
5. Confirma a linha `[Trono] Base de dados ativa: ...` no terminal.
6. Abre `mvp/client/project.godot` no Godot 4 e inicia com F5. O cliente carrega o nome guardado no Godot; caso contrário, pressiona N e introduz `John`.

## Segurança dos dados
- Não executes simultaneamente duas versões do servidor na porta 8000.
- Não apagues a base antiga até confirmares o progresso no jogo e após reiniciar o servidor.
- Para escolher uma localização alternativa, define `TRONO_DATA_DIR` **antes** de iniciar o servidor. Exemplo: `$env:TRONO_DATA_DIR='D:\Jogos\TronoFragmentado\data'`.
- Se extraíres o ZIP fora de uma pasta chamada `TronoFragmentado`, a localização predefinida passa a ser `%USERPROFILE%\TronoFragmentado\data`.
- O cliente e o servidor ainda são um protótipo local sem autenticação; não expor o servidor diretamente à internet.

## Testes de aceitação
- Confirma John nível 12 e ouro 2358 na primeira execução se a base central ainda não existia; valores podem variar após jogar.
- Compra, equipa e vende perto de Tessa; testa `I`, `M`, `Q`, `E`, `Esc`.
- Verifica colisões, combate e progresso após reiniciar o servidor.

## Validação realizada
- `python -m py_compile` do servidor: passou.
- Migração SQLite para diretório temporário com os dados do ZIP: passou (John nível 12, 2358 ouro).
- O Godot não está disponível neste ambiente para testar a compilação GDScript e a interface em execução; valida no Godot 4 antes de substituir a tua instalação atual.
