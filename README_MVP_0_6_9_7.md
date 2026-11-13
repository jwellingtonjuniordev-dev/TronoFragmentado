# MVP 0.6.9.7 — Sons de Profissões e Forja

Base: ZIP MVP 0.6.9.6 fornecido pelo utilizador.

## Novidades
- Sons originais gerados localmente, sem ficheiros externos: machado, picareta, erva, forja com sucesso e falha.
- Recolha: o som acompanha a animação quando o servidor envia `gather_result`.
- Forja: sons diferentes para `craft_result` bem-sucedido e falhado.
- Volume moderado (-11 dB recolha, -13 dB forja), sem alteração do servidor ou das probabilidades.
- A base SQLite não está incluída.

## Instalação
1. Fecha Godot e servidor. Faz backup de `characters.sqlite3` e de outros ficheiros SQLite do servidor.
2. Extrai para uma pasta nova. Mantém a mesma base de dados persistente que já usavas, sem sobrescrever.
3. Inicia o servidor como habitualmente, abre `client/project.godot` no Godot 4 e executa F5.
4. Testa G junto a árvore, rocha e erva; testa receitas com sucesso e falha; verifica que dia/noite, combate, inventário e comércio permanecem intactos.

## Validação
- Sintaxe do servidor Python verificada.
- Ficheiros WAV PCM mono 16-bit 22050 Hz verificados.
- ZIP testado. A execução do GDScript no Godot ainda precisa de teste no computador do utilizador.
