# MVP 0.6.1 — Animações direcionais

Base: MVP 0.6.0 enviado e validado pelo utilizador.

## Melhorias
- Os sprites existentes passam a usar os quatro sentidos (cima, baixo, esquerda, direita) de acordo com a movimentação.
- A animação de caminhada usa frames individuais e um relógio de movimento por entidade.
- Personagens parados mostram frame de repouso, evitando andar sem sair do lugar.
- Lobos e saqueadores orientam-se segundo os deslocamentos recebidos do servidor.
- O herói executa um arco animado de espada quando o servidor confirma um golpe.
- Monstros atingidos apresentam um flash de dano breve.
- Mantêm-se mapa 0.6.0, colisões, A*, clique direito com auto-combate, inventário e efeitos de texto.

## Como instalar
1. Fecha Godot e servidor.
2. Faz cópia de segurança da base central em `C:\Projects\TronoFragmentado\data\characters.sqlite3`.
3. Extrai o ZIP em nova pasta.
4. Em `mvp/server`, inicia `python -m uvicorn main:app --host 127.0.0.1 --port 8000`.
5. Abre `mvp/client/project.godot` e pressiona F5.

## Testes
- Caminha nas quatro direções com WASD e botão direito.
- Verifica que o sprite para quando o personagem para.
- Observa o movimento dos lobos e saqueadores.
- Ativa combate automático com T e verifica animação de golpe e reação do monstro.
- Confirma que o clique direito não desliga AUTO: ON.
- Confirma o nível, ouro, inventário e persistência.

## Limitações
O servidor não envia uma ação de ataque animada para os outros jogadores e a posição dos monstros chega por snapshots. Os efeitos visuais são aproximações locais. Esta versão ainda usa desenho em Node2D, não AnimatedSprite2D.
