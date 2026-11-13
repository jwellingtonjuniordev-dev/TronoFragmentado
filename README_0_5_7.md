# Crónicas do Trono Fragmentado — MVP 0.5.7

## Novidades
- Dano flutuante acima do inimigo atingido, baseado no evento `combat_hit` do servidor.
- Anel de impacto temporário.
- Breve efeito luminoso da espada quando o ataque é do personagem local.
- Recompensas de XP e ouro apresentadas acima do inimigo derrotado.
- Barras de vida e indicador do alvo preservados do MVP 0.5.6.2.
- Navegação com botão direito mantém o auto-combate ativo, como na versão validada.

## Instalação
1. Parar Godot e servidor.
2. Guardar cópia de segurança de `C:\Projects\TronoFragmentado\data\characters.sqlite3`.
3. Extrair ZIP para uma nova pasta.
4. Na pasta `mvp/server`: `python -m uvicorn main:app --host 127.0.0.1 --port 8000`.
5. Abrir `mvp/client/project.godot` e executar com F5.

## Testes
- Ataque manual e automático exibem dano, impacto e vida reduzida.
- Morte de lobo mostra XP e ouro.
- Clique direito não desliga auto-combate.
- Nível, inventário, loja e missões mantêm-se.
- Reiniciar servidor confirma persistência.

A base SQLite não está incluída neste ZIP. O servidor mantém a base centralizada existente.
