clc
clear all
close all

eta = 0.001; % Tasa de aprendizaje

rng('default'); % Reinicia configuración de parametros de aleatorizacion

load('data_mat.mat'); % Carga el data set
N = size(X,1); % Toma numero de observation

ind=randperm(N); %%% Se seleccionan los indices de forma aleatoria

Xtrain=X(ind(1:2000),:);
Xtest=X(ind(2001:end),:);
Ytrain=Y(ind(1:2000),:);
Ytest=Y(ind(2001:end),:);

%Se extienden las matrices
Xtrain=[Xtrain,ones(2000,1)];
Xtest=[Xtest,ones(N-2000,1)];

%%%%%%%%%%%%%
%%% Se aplica regresion logistica %%

W = regresionLogistica(Xtrain,Ytrain,eta);

% Encuentro error cuadratico mediokl
Yesti = (W'*Xtest')';
Yesti(Yesti>=0)=1;
Yesti(Yesti<0)=0;

Eficiencia=(sum(Yesti==Ytest))/length(Ytest);
Error=1-Eficiencia;

%     Texto=strcat('La eficiencia en prueba es: ',{' '},num2str(Eficiencia));
    Texto=['La eficiencia en prueba es: ',num2str(Eficiencia)];
    disp(Texto);
%     Texto=strcat('El error de clasificaci�n en prueba es: ',{' '},num2str(Error));
   
