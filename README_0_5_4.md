# Crónicas do Trono Fragmentado — MVP 0.5.4

## Novidades
- Inventário com slots clicáveis, ícones textuais, quantidades e descrição contextual ao passar o rato.
- Equipar itens da mochila com clique; retirar arma, escudo e armadura clicando nos slots equipados.
- Usar poções clicando no respetivo item.
- Mercado com botões de compra e venda clicáveis. A proximidade de Tessa continua validada no servidor.
- Mantidas as teclas I, M, Q, E, H e atalhos 1–8, colisões e combate.
- Persistência SQLite centralizada mantida sem alterar a estrutura dos dados.

## Instalação segura
1. **Parar o servidor Python antes de atualizar.**
2. Fazer backup de `C:\Projects\TronoFragmentado\data\characters.sqlite3` (caso exista), incluindo os ficheiros `-wal` e `-shm` se existirem; idealmente fazer o backup SQLite com o servidor parado.
3. Extrair o ZIP numa pasta nova, por exemplo `C:\Projects\TronoFragmentado\MVP_0_5_4`.
4. No PowerShell, entrar na pasta `mvp\server` da nova versão e iniciar `python -m uvicorn main:app --host 127.0.0.1 --port 8000`.
5. Verificar no terminal a mensagem `Base de dados ativa` e confirmar que é a mesma localização da versão 0.5.3.
6. Abrir `mvp\client\project.godot` no Godot 4 e executar F5.

## Testes recomendados
- Confirmar nível, ouro e inventário de John antes de qualquer operação.
- I: clicar numa arma da mochila para equipar; clicar no slot da arma equipada para a retirar.
- I: clicar numa poção quando a vida não estiver cheia.
- M: perto de Tessa, comprar um item e vender um material clicando.
- Confirmar que comprar/vender longe de Tessa continua bloqueado.
- Reiniciar servidor e Godot, confirmar persistência dos itens e atributos.

**Nota:** não inclui nova cópia de `characters.sqlite3`: a base central existente é a fonte de verdade. O servidor não a substitui quando já existe.

A validação automática confirmou a sintaxe Python e a integridade do ZIP. A execução do cliente GDScript requer teste no Godot local.
