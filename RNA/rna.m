clc
clear all
close all
load('data_mat.mat');
N=size(X,1); % Numero de muestras
repeticiones=10; %Numero de repeticiones

% Se hace la partici�n de las muestras en subconjuntos de entrenamiento y prueba
rng('default');
particion=cvpartition(N,'Kfold',repeticiones);

ecm = 0;
maxn = 10; % Numero de neuronas por capa oculta
n = [10 15]; %Numero de neuronas por ca
epochs = [400];
performance = zeros(1,repeticiones);

for l=1:length(n)
    % Recorre la malla de valores con el nro. de neuronas por capa
    hidLaySize = n(l);
    for j=1:length(epochs)
        % Iteracion con las epocas de entrenamiento
        epoch = epochs(j);
        for fold=1:repeticiones
            % Iteracion de los folds
            %Particiones de entrenamiento y validacion
            indices=particion.training(fold);
            Xtrain=X(particion.training(fold),:);
            Xtest=X(particion.test(fold),:);
            Ytrain=Y(particion.training(fold),:);
            Ytest=Y(particion.test(fold),:);
            
            %proceso de normalizacion
            [Xtrain,mu,sigma] = zscore(Xtrain);
            Xtest = (Xtest - repmat(mu,size(Xtest,1),1))./repmat(sigma,size(Xtest,1),1);

            %Se crea la red neuronal con tama�o de capa oculta n(i)
            net = feedforwardnet(hidLaySize);

            % Se establece el maximo numero de epocas para el modelo
            net.trainParam.epochs = epoch;
            net.trainParam.goal = 0.01;
            
            %entrenamiento de la red neuronal
            net = train(net, Xtrain', Ytrain');
            
            % Proceso de Validacion
            Yest = sim(net, Xtest');
            
            performance(fold) = mse(net, Ytrain',net(Xtrain'));
        end
        disp(string('hidLaySize ') + hidLaySize + string(' epoch ') + epoch + string(' performance obtenido ') + mean(performance));
    end
end
