# Exercício 1. Ping-pong leds
Implemente no kit de desenvolvimento Basys3 um circuito sequencial que permita jogar ping-pong leds com verificação de antecipação dos jogadores. Deve ser usada a técnica de instanciação por componentes
(port map).

Use os 16 leds para representar o movimento da bola, a qual deve-se deslocar a uma frequência de 10 Hz.

 Use um push button para o sinal de reset, dois switches para o lançamento dos jogadores (sw(0) para o jogador 1 e sw(15) para o jogador 2), apresente no displays de 7 segmentos da esquerda o placar do jogador 1 e no display de 7 segmentos da direita o placar do jogador 2 (os displays 1 e 2 devem ficar desligados).

 > Na condição de reset o placar é zero a zero e o jogador 1 começa o jogo. 
 
 > O jogador que primeiro chegar a 9 pontos vence o jogo.