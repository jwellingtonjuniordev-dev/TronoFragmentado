# MVP 1.1.0.7.5 — Sprites direcionais

Base: MVP 1.1.0.7.4. Nenhum sistema do servidor foi substituido.

- Adicionados 14 spritesheets normalizados para grelhas 8x4 de 160 px e originais preservados.
- Integrado movimento e ataque visual no renderizador existente de herois e monstros.
- Ataque tem prioridade sobre movimento, mantendo eventos e dano do servidor.
- Criada cena isolada `res://scenes/test/CharacterAnimations.tscn`.
- Preservados efeitos, barras de vida, inventario, equipamento, mapa e persistencia.

## Validacao manual
1. Abrir projeto Godot 4.7 e aguardar importacao.
2. Executar cena de teste, usar teclas 1-7, WASD e Espaco.
3. Verificar idle, caminhada em 4 direcoes, ataque parado e em movimento.
4. Iniciar servidor existente e cena principal, validar personagens e combate.
5. Confirmar direcoes e recortes visuais; a ordem das linhas e provisoria.

## Limites
- Nao foi executado Godot neste ambiente; ausencia de erros em runtime nao foi certificada.
- A normalizacao 1774x887 -> 1280x640 usa nearest e preserva originais.
- A aparencia dos equipamentos continua dependente do sistema anterior.
- A sincronizacao de ataque usa eventos de rede existentes; nao foram criados RPCs.
