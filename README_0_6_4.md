# Crónicas do Trono Fragmentado — MVP 0.6.4

## Baú antigo da floresta
- O baú das ruínas (mundo: 1735, 1060) agora é interativo.
- Aproxima-te e prime **F** para o abrir.
- Recompensa fixa: 75 ouro, 60 XP e 2 poções pequenas.
- Cada personagem pode abrir o baú uma única vez.
- O servidor verifica nome, identificador e distância antes de atribuir recompensas.
- O estado `opened_chests` é guardado no JSON do personagem dentro da base SQLite existente.
- O cliente recebe o estado no `profile` e mostra o baú como aberto, com indicação visual.
- Personagens antigos continuam compatíveis: `opened_chests` ausente é tratado como lista vazia.

## Instalação
1. Fecha o Godot e o servidor.
2. Faz uma cópia de segurança da base SQLite centralizada.
3. Extrai o ZIP numa pasta nova.
4. Inicia em `mvp/server`: `python -m uvicorn main:app --host 127.0.0.1 --port 8000`.
5. Abre `mvp/client/project.godot` e executa F5.

## Testes
- Abrir o baú com F perto das ruínas e confirmar as recompensas.
- Tentar abrir novamente: nenhuma recompensa adicional.
- Reiniciar servidor e cliente: o baú continua aberto para o mesmo personagem.
- Confirmar que personagens distintos podem obter a recompensa uma vez cada.
- Verificar A*, colisões, combate automático, inventário, missões e nível.

Não são incluídos ficheiros SQLite. A sintaxe Python foi validada, mas a execução no Godot ainda necessita de teste.
