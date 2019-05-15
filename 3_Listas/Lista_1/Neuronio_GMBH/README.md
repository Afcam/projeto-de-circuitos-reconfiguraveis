# Exercício 3. Projeto usando IP-Cores dos operadores em ponto flutuante.
Usando os operadores aritméticos em ponto flutuante de 27 bits, implemente em hardware o modelo matemático de um neurônio GMBH de segunda ordem e mapeie a sua solução no kit de desenvolvimento Basys3.

$$saida = f(x) = ax2 + bx + c$$

No Matlab/Octave implemente um modelo de referência do neurônio. Crie 100 valores aleatórios para a entrada. Os parâmetros a, b e c devem ser declarados como constantes em VHDL. Realize a simulação comportamental e estime o erro quadrático médio da solução em hardware.

Use os 16 switches do kit de desenvolvimento e o push button up (btnU) para entrar com o valor de x:

Se btnU = ‘1’ então x(26 downto 11) = sw; Senão x(10 downto 0) = sw(16 downto 6).

Da mesma maneira use os leds e o push button down (btnD) para apresentar a saída:

Se btnD = ‘1’ então led = saida(26 downto 11); Senão led = saida(10 downto 0).