# MVP 1.1.0.7.8 — Velkran e herói na cripta

Base: MVP 1.1.0.7.7. Arquivos originais mantidos nas versões anteriores.

- `client/assets/characters/velkran/move.png`: atlas de caminhada 8×4, 160×160.
- `client/assets/characters/velkran/attack.png`: atlas de ataque 8×4, 160×160.
- `client/scripts/main.gd`: renderiza Velkran na sala 4; renderiza herói com atlas da classe e orientação da caminhada; mantém restantes inimigos e combate.
- `server/main.py`: nome oficial do chefe da sala 4, sem alterar HP, dano ou recompensas.

## Teste
1. Abrir `mvp/client/project.godot` no Godot 4.7.2 e verificar o painel de erros.
2. Iniciar servidor em `mvp/server`: `python -m uvicorn main:app --host 127.0.0.1 --port 8000`.
3. Entrar na cripta com K; verificar herói da classe atual e caminhar nas quatro direções.
4. Atacar parado e em movimento; verificar retorno ao movimento.
5. Chegar à sala 4 e confirmar nome Velkran O Guardião da Cripta e sprite de machado verde.
6. Confirmar que o Guardião da Tempestade e o Guardião do Sino Partido no mapa não foram alterados.

Nota: orientação das linhas adotada: baixo, cima, esquerda, direita. Godot não disponível para teste de execução neste ambiente.
