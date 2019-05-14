% PCR 2019
% Engenharia Eletrônica
% Universidade de Brasilia
% 
% funcao my_meuron.m para N entradas
% recebe vetor de entradas x, w e bias

function out_neuron = my_neuron(x,a,b,c)

out_neuron = a.*(x^2) + b.*x + c;

end
