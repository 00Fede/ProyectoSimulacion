%% Modelo usando funciones discriminantes gaussianas
% Se hace uso del metodo de matlab classify para aplicar un modelo
% funciones discriminantes gaussianas al problema de clasificacion

clear all;
close all;
clc;

load('../data_mat.mat'); %%Cargo los datos

repeats = 10; %% numero de folds para el cross validation

N=size(X,1); %% numero de muestras

% genera repeats particiones aleatorias a partir de tamaño N usando metodo de 
% k-folds 
particion = cvpartition(N,'k',repeats);

Eficiencia = zeros(repeats,1);

for fold=1:repeats
    
    % toma particion fold para muestras de entrenamiento y prueba
    Xtrain=X(particion.training(fold),:);
    Xtest=X(particion.test(fold),:);
    Ytrain=Y(particion.training(fold),:);
    Ytest=Y(particion.test(fold),:);
    
    [Xtrain(:,[5:8,17,18]),mu,sigma] = zscore(Xtrain(:,[5:8,17,18]));
    Xtest(:,[5:8,17,18]) = (Xtest(:,[5:8,17,18]) - repmat(mu,size(Xtest(:,[5:8,17,18]),1),1))./repmat(sigma,size(Xtest(:,[5:8,17,18]),1),1);
    
    % clasifica cada fila de xtest en una de las clases de ytrain
    class = classify(Xtest,Xtrain,Ytrain);
    
    % calcula eficiencia para este fold.
    Eficiencia(fold)=(sum(Yesti==Ytest))/length(Ytest);
    %Error=1-Eficiencia;
    
end

% Calcula promedio de las eficiencia encontradas en cada de uno de los
% k-folds
efi = mean(Eficiencia);

Texto=['La eficiencia en prueba es: ',num2str(efi)];
disp(Texto);
Texto=['El error de clasificaci�n en prueba es: ',num2str(1-efi)];
disp(Texto);




