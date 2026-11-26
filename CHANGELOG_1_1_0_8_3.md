# MVP 1.1.0.8.3

- Dropdown para escolher herois guardados em SQLite, com consulta ao servidor via WebSocket.
- Desativado carregamento automatico do ultimo heroi para permitir selecao.
- Mantida a criacao de personagens com verificacao de nome e escolha definitiva da classe.
- Integrados os 71 icones oficiais e manifesto enviados, sem alterar IDs ou estatisticas.
- Base de dados dos utilizadores nao e substituida.

## Testes
1. Iniciar servidor na pasta mvp/server.
2. Iniciar Godot e escolher um heroi no dropdown.
3. Confirmar atributos e inventario do heroi escolhido.
4. Criar outro heroi com N e verificar atualizacao da lista.
5. Testar inventario, loja e ferreiro com os icones.
