% funcao para decodificar resultados obtidos pela arquitetura de hardware
% do neurônio de 4 entradas
% Estima-se o MSE usando a funcao my_nuron como modelo de referencia
close all
clc
clear all
N=100; % numero de vetores de teste aleatorios
EW=8; % tamanho do expoente
FW=18; % tamanho da mantissa

%% Constantes do VHDL 
a= 5.25; 
b= -7.3;
c= 2;
%% Leirura e comparação dos dados criados em VHDL


bin_outneuron= textread('res_neuron.txt', '%s');
X=textread('floatX.txt', '%f');

result_hw=zeros(N,1);
result_sw=zeros(N,1);

for i=1:N-1
    result_hw(i,1)=bin2float(cell2mat(bin_outneuron(i)),EW,FW);
    result_sw(i) = my_neuron(X(i),a,b,c); % f(x) = a*x^2+b*x+c
    erro(i) = sum((result_hw(i,:) - result_sw(i,:)).^2);
end

result_hw(1:10,:)
result_sw(1:10,:)
MSE = sum(erro)/N
plot(erro)
%stem(erro)

