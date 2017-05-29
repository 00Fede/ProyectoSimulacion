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
        AUC = zeros(1,rept);
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
            model = fitcdiscr(Xtrain,Ytrain,'DiscrimType','diagquadratic'); 
            % hace prediccion de muestras de validacion. El score es usado
            % para graficar la curva ROC
            [Yesti,score] = model.predict(Xtest);
            % Como interesa scores de clase 1, se divide probabilidad de
            % clase 1 sobre probabilidad de clase 0
            score = score(:,1)./score(:,2);
            % Actualiza el objeto de performance del clasificador con la
            % salida del clasificador Yesti, el ultimo argumento indica las
            % observaciones que fueron usados en la validacion actual
            classperf(CP,Yesti,particion.test(fold));
            % Necesaria unicamente para obtener Intervalo de Confianza
            eficiencia(fold) = sum(Yesti==Ytest)/length(Ytest);
            % Calculo de curva ROC
            [Xroc,Yroc,~,AUC(fold)] = perfcurve(Ytest,score,'0');
            plot(Xroc,Yroc);
            title('Curva ROC');
            xlabel('1 - Especificidad');
            ylabel('Sensibilidad');
            hold all;
        end
        % TODO: 
        Eficiencia = get(CP,'CorrectRate');
        Sensibilidad = get(CP,'Sensitivity');
        Especificidad = get(CP,'Specificity');
        Precision = get(CP,'PositivePredictiveValue'); %Precision
        IC = std(eficiencia);
        AUC = mean(AUC);
        ICAUC = std(AUC);
        
        Text = ['La eficiencia obtenida de funciones discr. gauss. es ',num2str(Eficiencia),' +-',num2str(IC)];
        disp(Text);
        Text = ['Sensibilidad: ',num2str(Sensibilidad)];
        disp(Text);
        Text = ['Especificidad: ',num2str(Especificidad)];
        disp(Text);
        Text = ['Precision: ',num2str(Precision)];
        disp(Text);
         % Escribo el desempe�o esperado del sistema
        Texto=['desempeno esperado del sistema (AUC) es = ', num2str(AUC),' +- ',num2str(ICAUC)];
        disp(Texto);
        %%% Fin Funciones discriminantes gaussianas %%%
        
    case 2
        % K vecinos
        X = X(:,[1:14,18,19]); % quitamos cols cuya var es 0
        k = 5;
        eficiencia = zeros(1,rept); %vector fila para guardar eficiencia de c/fold
        ecm = zeros(1,rept);
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
            
            %%% Normalizaci�n %%%
            [Xtrain,mu,sigma]=zscore(Xtrain);
            Xtest=normalizar(Xtest,mu,sigma);
            
            % Aplica modelo k-nearest a datos de entrenamiento y genera un
            % Yesti en base a Xtest
            Yesti = vecinosCercanos(Xtest,Xtrain,Ytrain,k);
            
            classperf(CP,Yesti,particion.test(fold));
            eficiencia(fold)=sum(Yesti==Ytest)/length(Ytest);
            % Se calcula Error Cuadratico Medio de Yesti y Ytest
            ecm(fold) = immse(Yesti,Ytest);

        end
        ecm = mean(ecm); % Promedio del error cuadratico medio
        Eficiencia = get(CP,'CorrectRate');
        Error = get(CP,'ErrorRate');
        Sensibilidad = get(CP,'Sensitivity');
        Especificidad = get(CP,'Specificity');
        Precision = get(CP,'PositivePredictiveValue'); %Precision
        IC = std(eficiencia);
        IC1 = std(ecm);
        
        Text = ['El ECM obtenido de K-nearest es ',num2str(ecm),' +-',num2str(IC1)];
        disp(Text);
        Text = ['La eficiencia obtenida de K-nearest es ',num2str(Eficiencia),' +-',num2str(IC)];
        disp(Text);
        Text = ['Sensibilidad: ',num2str(Sensibilidad)];
        disp(Text);
        Text = ['Especificidad: ',num2str(Especificidad)];
        disp(Text);
        Text = ['Precision: ',num2str(Precision)];
        disp(Text);
        Text = ['Tasa de Error: ',num2str(Error)];
        disp(Text);
        
        %%% Fin de K-nearest %%%
    case 3
        % RNA
    case 4
        % Random Forest
    case 5
        % SVM
    otherwise
        disp('Opcion no valida, Saliendo...');
end

