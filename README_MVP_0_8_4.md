# MVP 0.8.4 — Efeitos visuais de armas especiais

Atualizacao visual no cliente Godot. Nao modifica o servidor, atributos, probabilidades, inventario nem a SQLite.

## Armas
- Lamina real de Valedouro: brilho dourado, particulas e duplo rasto durante ataque.
- Espada ancestral: brilho violeta e particulas.
- Espada de aco do Guardiao: brilho ciano e particulas.

## Testes
1. Equipa cada uma das armas e verifica a cor da aura.
2. Ataca com ESPACO ou combate automatico e verifica o rasto temporario.
3. Desequipa a arma e verifica que o efeito desaparece.
4. Testa movimento, inventario, ferreiro e reinicio do servidor.

## Instalacao
Fecha Godot e servidor, faz backup da SQLite centralizada e abre o novo projeto. Nao copies bases de dados de versoes antigas.
