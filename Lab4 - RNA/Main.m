
% Con las siguientes tres instrucciones limpio:  
clc % Las funciones y salidas previamente escritas en el command window,
clear all % El workspace y todas las variables en la memoria del sistema,
close all % Y cierro todas las figuras creadas.
load('matlab.mat'); % Con esto cargo los datos para el problema de regresion
%%punto=input('Ingrese el punto que quiere realizar: ');
%%La entrada debe tener tantos nodos como variables
numeroVariables = 10;
nodos = 10;
%%Cada nodo tendrà un sub- ??ndice que indicar ?a la posici ?on del nodo en la
%%capa y un super- ??ndice que indicar ?a la capa a la cual pertence el nodo.

resultadoBP = backpropagation(100,400,800,1000);

%%

    
    % Exactamente se carga lo siguiente:
    %       Xreg = Matriz de 1030filas X 8 Columnas
    %       Yreg = Vector columna con 1030 valores
    %Xreg=Xreg(:,1:6); % Aqui selecciono y guardo en Xreg, todas las filas(muestras) pero solo escojo las columnas(caracteristicas) de la 1 a la 6
    
    %%% Se hace la partición entre los conjuntos de entrenamiento y prueba.
    %%% Esta partición se hace de forma aletoria %%%

    %%N=size(Xreg,1); % En N guardo el numero de muestras que tengo disponibles (N=1030)

    %%porcentaje=N*0.7; % Creo una variable porcentaje que es igual a:: porcentaje = 1030*0.7 = 721
    %%rng('default'); % Esto es para controlar la generacion de numeros aleatorios
    %%ind=randperm(N); %%% Se seleccionan los indices de forma aleatoria

    % Con las siguientes instrucciones divido el conjunto de datos en dos
    % partes, una para el entrenamiento y otra para la validacion.
    % El subconjunto de entrenamiento (Xtrain & Ytrain) consiste de 721
    % muestras seleccionadas al azar, y el subconjunto de validacion 
    % (Xtest & Ytest) se compone de las otras 309 muestras que tambien
    % estan puestas al azar.
    %%Xtrain=Xreg(ind(1:porcentaje),:);
    %%Xtest=Xreg(ind(porcentaje+1:end),:);
    %%Ytrain=Yreg(ind(1:porcentaje),:);
    %%Ytest=Yreg(ind(porcentaje+1:end),:);

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    %%% Normalización %%%

   %% [Xtrain,mu,sigma]=zscore(Xtrain);
   %% Xtest=normalizar(Xtest,mu,sigma);
    
    % ======== NOTA ======== 
    % Recuerde que las Y (salidas esperadas) NUNCA SE DEBEN NORMALIZAR
    % ====================== 
    
    %%%%%%%%%%%%%%%%%%%%%

    %%% Se aplica la regresión usando KNN  %%%
    
    % Entonces:
    %%k=100; % 1º Defino el numero o cantidad de vecinos 
    %%Yesti=vecinosCercanos(Xtest,Xtrain,Ytrain,k,'regress');
    
    
% % % Esto es una prueba
% % % Si descomenta estas instrucciones no olvide comentar
% % % la instruccion anterior para no tener problemas
% % %     N=size(Xtrain,1);
% % %     M=size(Xtest,1);
% % %     Yesti=zeros(M,1);
% % %     dis=zeros(N,M);
% % %     dis = repmat(sum(Xtrain.^2,2),1,M) + repmat(sum(Xtest.^2,2)',N,1) - 2*(Xtrain*Xtest');
% % %     dis = sqrt(dis);
% % %      [~, indices] = sort(dis', 2); 
% % %      indices = indices(:, 1:k);
% % %     temp = Ytrain(indices);
% % %     Yesti = mean(Ytrain(indices), 2);
% % % Hasta aqui la prueba

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    %%% Se encuentra el error cuadratico medio %%%

    %%ECM=(sum((Yesti-Ytest).^2))/length(Ytest);

    %%Texto=strcat('El Error cuadrático medio en prueba es: ',{' '},num2str(ECM));
    %%disp(Texto);

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  
