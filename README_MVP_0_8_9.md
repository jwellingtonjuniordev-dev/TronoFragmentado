# MVP 0.8.9 — Controlos de combate

- Clique esquerdo no cenário: ataque básico (o servidor escolhe alvo dentro de 65 px).
- Clique direito no cenário: caminhar/pathfinding.
- 1: Golpe Arcano; 2: habilidade da classe. Sem ataque básico na barra.
- C: abrir/fechar painel de classes; selecionar Guerreiro/Mago/Arqueiro com clique esquerdo.
- T: combate automático.
- H: poção de vida; J: poção de mana (+50 MP).
- V, K, R, Espaço e teclas 3-8 não ativam habilidades/forja.
- Mana: 100 MP base; Golpe Arcano custa 15 MP; habilidade de classe custa 25 MP.
- Para testar: ao carregar um herói pela primeira vez nesta versão, recebe 5 poções de mana, apenas uma vez. Monstros podem deixar uma poção de mana com 15% de probabilidade.

Não incluímos a SQLite. Faça uma cópia de segurança da base de dados central antes de instalar.
Não foi possível executar o Godot neste ambiente; valide no editor e reporte quaisquer erros.
