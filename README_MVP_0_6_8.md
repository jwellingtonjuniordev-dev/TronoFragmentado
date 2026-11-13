# MVP 0.6.8 — Pulso do Guardião e cura visual

Base: MVP 0.6.7.3 enviado pelo utilizador.

- Poção pequena: evento `healing_effect` com HP realmente recuperado (máximo 35), exibido em verde sobre o personagem.
- Sem poções ou com HP cheio, não há cura nem indicador falso.
- Guardião das Ruínas: ataque especial `Pulso das Ruínas`, a cada 9 segundos, se houver alvo a até 92 px. Dano base 28, reduzido pela defesa, mínimo 1.
- Evento visual `guardian_special` com anúncio violeta e valor do dano recebido. O Guardião utiliza a animação de ataque já existente.
- Cálculo de dano, cooldown e vida são autoritativos no servidor.
- Não altera tabelas SQLite, drops, equipamentos, missões nem baús.

Instalação: fecha servidor e Godot; guarda uma cópia da SQLite centralizada; extrai numa pasta nova; inicia o servidor em mvp/server com `python -m uvicorn main:app --host 127.0.0.1 --port 8000`; abre mvp/client/project.godot no Godot 4.

Testes: perder 10 HP e usar uma poção (deve mostrar +10 HP); perder pelo menos 35 HP (deve mostrar +35 HP); tentar com HP cheio (não consome); enfrentar Guardião por mais de 9 segundos e verificar Pulso das Ruínas, dano e redução de vida; validar persistência, A*, loot, baús e missões.

Validação: sintaxe Python compilada; integridade ZIP verificada. Não foi possível executar o Godot neste ambiente.
