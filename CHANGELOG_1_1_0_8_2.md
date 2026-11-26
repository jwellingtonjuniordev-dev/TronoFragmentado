# MVP 1.1.0.8.2

- Icones oficiais de 13 itens importados de amostras_icones_mvp1093(1).zip e utilizados no inventario.
- Validacao de disponibilidade de nomes no servidor antes da selecao de classe para novos herois.
- Classe escolhida pelo dropdown apos nome disponivel; criacao com verificacao adicional para evitar substituir personagem existente.
- Personagens sem arma equipada utilizam a textura desarmada; os atlas com armas embutidas sao utilizados apenas quando a arma esta equipada.
- Evita duplicar overlays de armas/escudos sobre atlas que ja contem equipamento.
- Personagens antigos continuam acessiveis pelo carregamento automatico configurado.

## Limitacao
O atlas da classe contem arma desenhada no proprio PNG. A aparencia desarmada usa o sprite alternativo existente.
