clc
clear all
close all
N=100; % numero de vetores de teste aleatorios
EW=8; % tamanho do expoente
FW=18; % tamanho da mantissa
% valores de entrada entre 0 e 1.0
% max_in = 20.0 % pesos com valores entre 0 e 10.0

float2bin(EW,FW,0.5)
float2bin(EW,FW,0.1)

float2bin(EW,FW,0.6)
g1 = 0.5/0.6
float2bin(EW,FW,g1)
s1 = 0.1 - g1*0.1

float2bin(EW,FW,s1)