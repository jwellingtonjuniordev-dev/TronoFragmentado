# Arquitetura do protótipo

```text
Godot 4 (cliente) <-- WebSocket JSON --> FastAPI (servidor)
                                            |
                                            +--> simulação do mundo e combate
                                            +--> validação de missões e recompensas
                                            +--> SQLite (personagens e mundo)
```

## Cliente
`client/scripts/main.gd` implementa apresentação do mundo, HUD, efeitos, input e envio de intenções. Não deve atribuir ouro, XP ou loot localmente.

## Servidor
`server/main.py` mantém entidades, valida movimento, combate, interações, drops, fases de chefe e persistência. A implementação atual concentra funcionalidades num ficheiro e será modularizada progressivamente.

## Persistência
Personagens guardados por nome e estado serializado em SQLite. A evolução futura requer autenticação, sessões, migrações explícitas, transações e controlo de concorrência antes de disponibilizar servidores públicos.

## Limites conhecidos
Protótipo local sem autenticação robusta, escalabilidade, instâncias reais de dungeon ou pipeline de testes do Godot em CI. Não expor a porta do servidor diretamente na internet.
