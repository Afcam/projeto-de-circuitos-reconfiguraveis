clc
clear all
close all
N=100; % numero de vetores de teste aleatorios
EW=8; % tamanho do expoente
FW=18; % tamanho da mantissa
% valores de entrada entre 0 e 1.0

float_xir = fopen('float_xir.txt','w');
float_xul = fopen('float_xul.txt','w');

bin_xir = fopen('bin_xir.txt','w');
bin_xul = fopen('bin_xul.txt','w');

coe_xir = fopen('coe_xir.coe','w');
fprintf(coe_xir,'memory_initialization_radix=2;\n');
fprintf(coe_xir,'memory_initialization_vector=\n');

coe_xul = fopen('coe_xul.coe','w');
fprintf(coe_xul,'memory_initialization_radix=2;\n');
fprintf(coe_xul,'memory_initialization_vector=\n');

% rand('seed',06111991); % seed for random number generator
rand('twister',160024242); % seed for random number generator

for i=1:N
    xir=rand();
    xul=rand();
    
    xirbin=float2bin(EW,FW,xir);
    xulbin=float2bin(EW,FW,xul); 
    
    fprintf(float_xir,'%f\n',xir);
    fprintf(float_xul,'%f\n',xul);

    fprintf(bin_xir,'%s\n',xirbin);
    fprintf(bin_xul,'%s\n',xulbin);

    if i == N
        fprintf(coe_xir,'%s;',xirbin);
        fprintf(coe_xul,'%s;',xulbin);
    else
        fprintf(coe_xir,'%s,\n',xirbin);
        fprintf(coe_xul,'%s,\n',xulbin);
    end   
end

fclose(float_xir);
fclose(float_xul);

fclose(bin_xir);
fclose(bin_xul);

fclose(coe_xir);
fclose(coe_xul);
