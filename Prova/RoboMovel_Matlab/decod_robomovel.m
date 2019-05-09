% funcao para decodificar resultados obtidos pela arquitetura de hardware
% do Robo Movel
% Estima-se o MSE usando a funcao robo_movel como modelo de referencia

close all
clc
clear all
N = 100; % numero de vetores de teste aleatorios
EW = 8; % tamanho do expoente
FW = 18; % tamanho da mantissa

bin_result = textread('Resultados_RoboMovel.txt', '%s');

xir = textread('float_xir.txt', '%f');
xul = textread('float_xul.txt', '%f');

result_hw = zeros(N, 1);
result_sw = zeros(N, 1);
sigma_z = 0.5;
sigma_k = 0.1;
for i = 1:N - 1
    result_hw(i, 1) = bin2float(cell2mat(bin_result(i)), EW, FW);
    ganho = sigma_k/(sigma_k+sigma_z); %>
    result_sw(i) = xul(i) + ganho*(xir(i)-xul(i));
    sigma_k = sigma_k - ganho*(sigma_k);
    erro(i) = sum((result_hw(i, :) - result_sw(i, :)) .^ 2);
end

result_hw(1:10, :)
result_sw(1:10, :)

(result_hw-result_sw)(1:10, :)
MSE = sum(erro) / N
plot(erro)
