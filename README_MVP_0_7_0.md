# MVP 0.7.0 — Profissões

Esta versão adiciona progressão independente de Lenhador, Mineiro e Herbalista.

- Recolha válida de madeira: +12 XP Lenhador.
- Recolha válida de rocha: +16 XP Mineiro.
- Tentativa válida de recolha de erva: +20 XP Herbalista, mesmo sem encontrar a erva rara.
- O nível da profissão aumenta com experiência acumulada. O servidor calcula e guarda a progressão em SQLite.
- Tecla **P** abre/fecha o painel das três profissões, com nível, experiência e barra de progresso.
- Quando sobe de nível, aparece um texto flutuante.
- Não há ainda bônus de rendimento ou novas ferramentas; isso fica para a próxima etapa.

## Instalação segura

Feche o servidor e o Godot, faça backup da base SQLite centralizada e extraia esta versão numa pasta nova. O ZIP não inclui bancos de dados. Inicie o servidor como anteriormente e abra `mvp/client/project.godot` no Godot 4.

## Testes

1. Abra o painel com P.
2. Recolha madeira, rocha e erva e confira XP específico.
3. Recolha até subir um nível e confira aviso.
4. Reinicie o servidor e confirme que a experiência das profissões foi recuperada.
5. Teste combate, missões, loja, crafting, baús, noite/dia e recursos dinâmicos.

Validação automatizada: compilação Python e integridade do ZIP. Execução Godot não realizada neste ambiente.
