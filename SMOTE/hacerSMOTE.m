%% Funcion para aplicar SMOTE
clc
clear all

% Se obtiene BD con variables codificadas
load('../data_mat_enc.mat');

rng('default');
% Se aplica SMOTE
[X,Y] = SMOTE(X,Y,8,0.3);
% Se redondean los valores encontrados
X = round(X);
% Se permutan los indices para dar mas aleatoriedad
N = size(X,1);
indperm = randperm(N);
X = X(indperm',:);
Y= Y(indperm);
% Se guarda nuevo data set en data_smoted
save('../data_smoted.mat','X','Y');

