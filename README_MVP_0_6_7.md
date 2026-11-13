# MVP 0.6.7 — Guardião das Ruínas

Nova criatura especial nas ruínas da floresta (x=1560, y=1050).

- Guardião: 420 HP, perseguição até 200 px, ataque de base 22 (antes de defesa), cadência 2,3 s.
- Recompensa: 350 XP, 250 ouro e um Selo das Ruínas no inventário.
- Respawn do guardião após 180 segundos; outros monstros mantêm o comportamento anterior.
- Aparência ampliada com aura violeta, bastão e barra de vida própria.
- A luta usa o mesmo sistema autoritativo do servidor e o combate automático existente.
- Nenhuma alteração ao esquema SQLite; progresso anterior preservado.

Instalação: fechar Godot e servidor; fazer backup da base central; extrair; iniciar o servidor na pasta mvp/server com `python -m uvicorn main:app --host 127.0.0.1 --port 8000`; abrir mvp/client/project.godot e pressionar F5.

Testes: localizar guardião perto das ruínas, observar a aura e barra de vida, combater manual e automaticamente, verificar loot e respawn, confirmar os baús, missões, colisões e persistência.

Nota: a aparência do guardião reutiliza o sprite do saqueador com efeitos adicionais; é um chefe de protótipo, não um sprite final exclusivo. Godot não foi executado neste ambiente.
