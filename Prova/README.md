# Curso de Graduação em Engenharia Eletrônica - Faculdade Gama - Universidade de Brasília
### Disciplina: Projeto com Circuitos Reconfiguráveis (período 2019.1)


## Um robô móvel usa medidas de distância aos obstáculos através de um sensor de ultrassom e de um sensor de infravermelho. Deseja-se fazer a fusão sensorial dos sensores no intuito de melhorar a estimativa do valor de distância medida pelo robô. Para isto as equações (1), (2) e (3) são usadas. A cada instante de tempo k duas novas medidas (xUL e xIR) são realizadas e um novo valor da distância pode ser estimado através da fusão sensorial.

$$ x_{fusao}=x_{UL}+G_{k+1} ( x_{IR} - x_{UL})$$
$$\sigma^2_{k+1} = \sigma^2_{k}- G_{k+1}\sigma^2_{k} $$
$$G_{k+1} =\frac{\sigma^2_{k}}{\sigma^2_{k}+\sigma^2_{z}}  $$
onde,
  * $x_{fusao}$ é a estimativa da fusão dos dois sensores em centímetros
  * $x_{UL}$ é a medida do sensor de ultrassom em centímetros
  * $x_{IR}$ é a medida do sensor de infravermelho em centímetros
  * $\sigma^2_{z}$ é o erro de covariância associado ao sensor de infravermelho
  * $\sigma^2_{k}$ é o erro de covariância associado ao sensor de ultrassom no instante k.
  * $\sigma^2_{k+1}$ é o erro de covariância da fusão no instante de tempo k+1.
  * $G_{k+1}$ é conhecido como Ganho do filtro e é calculado a cada instante de tempo k

## Diagrama de Blocos

![grafico](Imagens/arquitetura2.jpg)

![grafico](Imagens/schematic31.png)










<!-- <p>Este é um parágrafo.</p>
<p>Este é outro parágrafo.</p>

Javascript é _cool_! -->
<!-- - [x] Finish my changes
- [ ] Push my commits to GitHub
- [ ] Open a pull request -->