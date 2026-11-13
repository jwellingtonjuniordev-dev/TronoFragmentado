# Crónicas do Trono Fragmentado — MVP 0.5.8

## Novidades visuais
- Estradas com rebordos, desgaste e pequenas irregularidades.
- Relva mais variada, pequenas flores e tufos decorativos.
- Casas com telhas, alicerces de pedra, soleiras e lanternas.
- Árvores com folhas realçadas e rochas com detalhes.

**Sem alterações de colisão, navegação A*, combate, eventos de dano ou persistência SQLite.** As decorações são apenas gráficas e não bloqueiam o personagem.

## Instalação
1. Fechar Godot e servidor Python.
2. Fazer cópia de segurança da base de dados centralizada em `C:\Projects\TronoFragmentado\data\characters.sqlite3`.
3. Extrair o ZIP para uma nova pasta.
4. No diretório `mvp/server`, iniciar `python -m uvicorn main:app --host 127.0.0.1 --port 8000`.
5. Abrir `mvp/client/project.godot` no Godot e executar F5.

## Testes
- Verificar novos detalhes das casas e caminhos.
- Confirmar que não existem erros de parser no Godot.
- Testar colisões e movimentação por clique em redor de casas e árvores.
- Testar combate automático e números de dano por cima do cenário.
- Confirmar inventário, ouro, nível e persistência após reinício.

O ZIP não inclui bases SQLite nem cache `.godot`.
