clc
clear all
close all
N=100; % numero de vetores de teste aleatorios
EW=8; % tamanho do expoente
FW=18; % tamanho da mantissa

floatX = fopen('floatX.txt','w');
binX = fopen('binX.txt','w');

rand('twister',160024242); % seed for random number generator
for i=1:N
    X=100*rand(); % valores entre 0 e 100
    
    Xbin=float2bin(EW,FW,X);
   
    fprintf(floatX,'%f\n',X);
    fprintf(binX,'%s\n',Xbin);
    
end

fclose(floatX);
fclose(binX);