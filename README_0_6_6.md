# MVP 0.6.6 — Missão de exploração da floresta

## Missão
- Depois de concluir «A proteção de Valedouro», fala novamente com Tessa (E).
- Aceita «Exploração da Floresta»: abre dois baús **diferentes** enquanto a missão está ativa.
- Os baús continuam a conceder as suas recompensas habituais e a ter cooldown de 5 minutos.
- Volta a Tessa para receber **200 XP, 150 ouro e 3 poções**.
- A missão é concluída uma única vez por personagem.
- O progresso e a conclusão são guardados na mesma base SQLite centralizada.
- Diário Q mostra a missão e o progresso 0/2, 1/2, 2/2.

## Compatibilidade
- Personagens anteriores recebem valores padrão para os novos campos.
- A base SQLite não é incluída no ZIP.
- Não são alterados os algoritmos A*, combate, respawn dos baús ou mapa.

## Instalação
1. Fecha Godot e servidor; faz backup da base SQLite central.
2. Extrai o ZIP numa nova pasta.
3. Na pasta `mvp/server`: `python -m uvicorn main:app --host 127.0.0.1 --port 8000`.
4. Abre `mvp/client/project.godot` no Godot e pressiona F5.

## Testes
- Confirmar progresso do personagem e abrir Q.
- Falar com Tessa depois da primeira missão e aceitar exploração.
- Abrir 2 baús diferentes (um mesmo baú repetido não conta duas vezes).
- Reiniciar servidor antes de entregar e confirmar progresso persistido.
- Voltar a Tessa para entregar e verificar recompensas uma só vez.
- Verificar que baús continuam a reaparecer após 5 minutos.

Nota: sintaxe do servidor validada, mas ainda é necessário testar a execução no Godot.
