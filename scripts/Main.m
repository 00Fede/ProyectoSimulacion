%% Este Script contiene toda la lógica necesaria para hacer la prueba de
% los diferentes modelos de simulación en el data-set.
% Se asume que las variables fueron codificadas respectivamente y se hizo
% selección de variables previo.
clc
clear all;

punto=input('Seleccione:\n1 - Funciones Discriminantes Gaussianas\n2 - K-vecinos\n3 - Redes Neuronales Artificiales\n4 - Random Forest\n5 - Maquinas de Soporte Vectorial\n');

load('../data_smoted.mat'); %% Carga BD con variables codificadas


rept = 10;  % Numero de pliegues, repeticiones para cv
N = size(X,1); % Numero de muestras

switch(punto)
    case 1
        % Funciones Discriminantes Gaussianas
        X = X(:,[1:14,18,19]); % quitamos cols cuya var es 0
        eficiencia = zeros(1,rept); %vector fila para guardar eficiencia de c/fold
        rng('default');
        particion = cvpartition(N,'k',rept);  %genera validación cruzada
        % Crea e inicializa un objeto de performance de clasificador, Y son
        % los truelabels de cada una de las observaciones. Permite mantener
        % un completo escaneo del performance del clasificador
        CP = classperf(Y); 
        for fold=1:rept
            Xtrain=X(particion.training(fold),:);
            Ytrain=Y(particion.training(fold));
            Xtest=X(particion.test(fold),:);
            Ytest=Y(particion.test(fold));
            
            % Genera el modelo con las muestra de entrenamiento
            model = fitcdiscr(Xtrain,Ytrain,'DiscrimType','diaglinear'); 
            % hace prediccion de muestras de validacion
            Yesti = model.predict(Xtest);
            % Actualiza el objeto de performance del clasificador con la
            % salida del clasificador Yesti, el ultimo argumento indica las
            % observaciones que fueron usados en la validacion actual
            classperf(CP,Yesti,particion.test(fold));
            % Necesaria unicamente para obtener Intervalo de Confianza
            eficiencia(fold) = sum(Yesti==Ytest)/length(Ytest);
            
        end
        % TODO: 
        Eficiencia = get(CP,'CorrectRate');
        Sensibilidad = get(CP,'Sensitivity');
        Especificidad = get(CP,'Specificity');
        Precision = get(CP,'PositivePredictiveValue'); %Precision
        IC = std(eficiencia);
        
        Text = ['La eficiencia obtenida de funciones discr. gauss. es ',num2str(Eficiencia),' +-',num2str(IC)];
        disp(Text);
        Text = ['Sensibilidad: ',num2str(Sensibilidad)];
        disp(Text);
        Text = ['Especificidad: ',num2str(Especificidad)];
        disp(Text);
        Text = ['Precision: ',num2str(Precision)];
        disp(Text);
        %%% Fin Funciones discriminantes gaussianas %%%
        
    case 2
        % K vecinos
        
        
        
        
    case 3
        % RNA
    case 4
        % Random Forest
    case 5
        % SVM
    otherwise
        disp('Opcion no valida, Saliendo...');
end

