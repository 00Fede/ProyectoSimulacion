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
% Cell array con diferentes vars seleccionadas por varios metodos
% en orden: Conj. Conclusion, SFS, ,PCA, LASSO
varsSelected = [{[1,3,4,7,10,11,12]},{[6,7,8,11,12,19]},{[1:10]},{[1,2,5,10,11,12]},{[1:14,18,19]},{[1,2,3,5,6,7,8,11,18,19]}];

% Se genera objeto de validación cruzada
particion = cvpartition(N,'k',rept);  

switch(punto)
    case 1
        % Funciones Discriminantes Gaussianas
        % X = X(:,[1:14,18,19]); % quitamos cols cuya var es 0
        eficiencia = zeros(1,rept); %vector fila para guardar eficiencia de c/fold
        AUC = zeros(1,rept);
        % Tipo de discriminante
        tipo = [{'linear'},{'diaglinear'},{'pseudolinear'}];
        rng('default');
        particion = cvpartition(N,'k',rept);  %genera validación cruzada
        % Crea e inicializa un objeto de performance de clasificador, Y son
        % los truelabels de cada una de las observaciones. Permite mantener
        % un completo escaneo del performance del clasificador
        % CP = classperf(Y);
        mallamedidas = zeros(length(tipo),6);
        for sel=1:length(varsSelected)
            text = ['%%%% Grupo de variables candidata ', num2str(sel)];
            disp(text);
            Xajustada = X(:,varsSelected{sel});
            for discrimType=1:length(tipo)
                Texto = ['Funcion discriminante gaussiana con tipo de frontera ',tipo{discrimType}];
                disp(Texto);
                hold off;
                CP = classperf(Y);
                for fold=1:rept

                    Xtrain=Xajustada(particion.training(fold),:);
                    Ytrain=Y(particion.training(fold));
                    Xtest=Xajustada(particion.test(fold),:);
                    Ytest=Y(particion.test(fold));

                    % Genera el modelo con las muestra de entrenamiento
                    model = fitcdiscr(Xtrain,Ytrain,'DiscrimType',tipo{discrimType}); 
                    % hace prediccion de muestras de validacion. El score es usado
                    % para graficar la curva ROC
                    [Yesti,score] = model.predict(Xtest);
                    % Como interesa scores de clase 1, se divide probabilidad de
                    % clase 1 sobre probabilidad de clase 0
                    score = score(:,2)./score(:,1);
                    % Actualiza el objeto de performance del clasificador con la
                    % salida del clasificador Yesti, el ultimo argumento indica las
                    % observaciones que fueron usados en la validacion actual
                    classperf(CP,Yesti,particion.test(fold));
                    % Necesaria unicamente para obtener Intervalo de Confianza
                    eficiencia(fold) = sum(Yesti==Ytest)/length(Ytest);
                    % Calculo de curva ROC
                    [Xroc,Yroc,~,AUC(fold)] = perfcurve(Ytest,score,'1');
                    plot(Xroc,Yroc);
                    title('Curva ROC');
                    xlabel('1 - Especificidad');
                    ylabel('Sensibilidad');
                    hold on;
                end
                Eficiencia = get(CP,'CorrectRate');
                Sensibilidad = get(CP,'Sensitivity');
                Especificidad = get(CP,'Specificity');
                Precision = get(CP,'PositivePredictiveValue'); %Precision
                IC = std(eficiencia);
                AUC = mean(AUC);
                ICAUC = std(AUC);
                
                mallamedidas(discrimType+(length(tipo)*(sel-1)),:) = [Eficiencia,IC,Sensibilidad,Especificidad,Precision,AUC];
                
                disp(num2str(Eficiencia));
                disp(num2str(IC));
                disp(num2str(Sensibilidad));
                disp(num2str(Especificidad));
                disp(num2str(Precision));
                disp(num2str(AUC));
        
%                 Text = ['Eficiencia ',num2str(Eficiencia),' +-',num2str(IC)];
%                 disp(Text);
%                 Text = ['Sensibilidad: ',num2str(Sensibilidad)];
%                 disp(Text);
%                 Text = ['Especificidad: ',num2str(Especificidad)];
%                 disp(Text);
%                 Text = ['Precision: ',num2str(Precision)];
%                 disp(Text);
%                  % Escribo el desempe�o esperado del sistema
%                 Texto=['desempeno esperado del sistema (AUC):', num2str(AUC),' +- ',num2str(ICAUC)];
%                 disp(Texto);
            end
        end
        % TODO: 
        
        %%% Fin Funciones discriminantes gaussianas %%%
        
    case 2
        % K vecinos
        % X = X(:,[1:14,18,19]); % quitamos cols cuya var es 0
        k = [5,10,15,20,25]; % numero de k-vecinos a evaluar
        eficiencia = zeros(1,rept); %vector fila para guardar eficiencia de c/fold
        ecm = zeros(1,rept);
        rng('default');
        
        % Crea e inicializa un objeto de performance de clasificador, Y son
        % los truelabels de cada una de las observaciones. Permite mantener
        % un completo escaneo del performance del clasificador
%         CP = classperf(Y); 
        mallamedidas = zeros(length(k),7);
        for sel=1:length(varsSelected)
            text = ['%%%% Grupo de variables candidata ', num2str(sel)];
            disp(text);
            Xajustada = X(:,varsSelected{sel});
            for kvec=1:length(k)
                Texto = ['Numero de k vecinos ',num2str(k(kvec))];
                disp(Texto);
                hold off;
                
                CP = classperf(Y); 
                for fold=1:rept
                    Xtrain=Xajustada(particion.training(fold),:);
                    Ytrain=Y(particion.training(fold));
                    Xtest=Xajustada(particion.test(fold),:);
                    Ytest=Y(particion.test(fold));

                    %%% Normalizaci�n %%%
                    [Xtrain,mu,sigma]=zscore(Xtrain);
                    Xtest=normalizar(Xtest,mu,sigma);

                    % Aplica modelo k-nearest a datos de entrenamiento y genera un
                    % Yesti en base a Xtest
                    Yesti = vecinosCercanos(Xtest,Xtrain,Ytrain,k(kvec));

                    classperf(CP,Yesti,particion.test(fold));
                    eficiencia(fold)=sum(Yesti==Ytest)/length(Ytest);
                    % Se calcula Error Cuadratico Medio de Yesti y Ytest
                    ecm(fold) = immse(Yesti,Ytest);
                    
%                     [Xroc,Yroc,~,AUC(fold)] = perfcurve(Ytest,score,'1');
%                     plot(Xroc,Yroc);
%                     title('Curva ROC');
%                     xlabel('1 - Especificidad');
%                     ylabel('Sensibilidad');
%                     hold on;

                end
                IC1 = std(ecm);
                ecm = mean(ecm); % Promedio del error cuadratico medio
                Eficiencia = get(CP,'CorrectRate');
                Error = get(CP,'ErrorRate');
                Sensibilidad = get(CP,'Sensitivity');
                Especificidad = get(CP,'Specificity');
                Precision = get(CP,'PositivePredictiveValue'); %Precision
                IC = std(eficiencia);
                
                mallamedidas(kvec+(length(k)*(sel-1)),:) = [ecm,IC1,Eficiencia,IC,Sensibilidad,Especificidad,Precision];
                disp(num2str(ecm));
                disp(num2str(IC1));
                disp(num2str(Eficiencia));
                disp(num2str(IC));
                disp(num2str(Sensibilidad));
                disp(num2str(Especificidad));
                disp(num2str(Precision));
%                disp(num2str(AUC));
        
%                 Text = ['El ECM obtenido de K-nearest es ',num2str(ecm),' +-',num2str(IC1)];
%                 disp(Text);
%                 Text = ['La eficiencia obtenida de K-nearest es ',num2str(Eficiencia),' +-',num2str(IC)];
%                 disp(Text);
%                 Text = ['Sensibilidad: ',num2str(Sensibilidad)];
%                 disp(Text);
%                 Text = ['Especificidad: ',num2str(Especificidad)];
%                 disp(Text);
%                 Text = ['Precision: ',num2str(Precision)];
%                 disp(Text);
%                 Text = ['Tasa de Error: ',num2str(Error)];
%                 disp(Text);
            end
        end
        
        %%% Fin de K-nearest %%%
    case 3
        % RNA
        HiddenLayerSize = [5,8]; % Num of hidden layer size
        epochs = [100,400,800,1000]; % num of epochs
        perf = zeros(1,rept); % performance array
        ecm = zeros(1,rept); % array con los ECM de cada iters
        eficiencia = zeros(1,rept); %vector fila para guardar eficiencia de c/fold
        AUC = zeros(1,rept);
        % Aqui se guardaran todos los resultados
        mallamedida = zeros(length(varsSelected)*length(HiddenLayerSize)*length(epochs),10);
        trainFcn = 'trainscg';
        for sel=1:length(varsSelected)
            % Ciclo para variables seleccionadas
            text = ['%%%% Metodo de Seleccion ', num2str(sel)];
            disp(text);
            Xajustada = X(:,varsSelected{sel}); % Se seleccionan solo variables segun metodo sel
            for indLayer=1:length(HiddenLayerSize)
                % For para numero de capas ocultas
                hidLaySize = HiddenLayerSize(indLayer);
                for indEpoch=1:length(epochs)
                    % For para c/num de epocas
                    epoch = epochs(indEpoch);
                    % Crea e inicializa un objeto de performance de clasificador, Y son
                    % los truelabels de cada una de las observaciones. Permite mantener
                    % un completo escaneo del performance del clasificador
                    CP = classperf(Y);
                    hold off;
                    for fold=1:rept
                        % for de crossvalidacion
                        Xtrain=Xajustada(particion.training(fold),:);
                        Ytrain=Y(particion.training(fold));
                        Xtest=Xajustada(particion.test(fold),:);
                        Ytest=Y(particion.test(fold));
                        
                        %%% Normalizaci�n %%%
                        [Xtrain,mu,sigma]=zscore(Xtrain);
                        Xtest=normalizar(Xtest,mu,sigma);
                        
                        net = patternnet(hidLaySize,trainFcn);
                        
                        % Parametros de division: indican porcentaje de X
                        % usado para train, validacion y pruebas,
                        % respectivamente
                        net.divideParam.trainRatio = 100/100;
                        net.divideParam.valRatio = 0/100;
                        net.divideParam.testRatio = 0/100;
                        
                        % Se ajustan paramentros de la red
                        net.trainParam.epochs = epoch;
                        % Se establece goal o porcentaje de rendimiento,
                        % sera el limite y cuando llegue a este valor se
                        % para el entrenamiento
                        net.trainParam.goal = 0.01;
                        
                        % para valores del gradiente muy pequenos es
                        % improbable una mejoria en el modelo
                        % net.trainParam.min_grad = 0;
                        % Valor de regularizacion para obtener el
                        % performance.
                        net.performParam.regularization = 0.01;
                        
%                         net.trainParam.min_grad
                        %habilita o deshabilita ventana de info de red
                        % net.trainParam.showWindow = 0;
                        
                        % Entrenamiento de RNA: muestras de entrenamiento
                        % deben transponerse para usar train
                        net = train(net,Xtrain',Ytrain');
                        
                        % Se utilizan muestras de validacion para
                        % predicciones
                        Yesti = sim(net,Xtest');
                        % Score utilizado para el ROC
                        score = Yesti;
                        % Se redondea salida para corresponder a clases
                        Yesti = round(Yesti);
                        
                        % Actualiza las medidas de desempeño
                        classperf(CP,Yesti',particion.test(fold));
                        % Obtiene el performance para la red, en base a los
                        % valores de entrenamiento, una medida difernete es
                        % usada para la validacion. Recordar que entre
                        % menor sea el performance, mejor es el nivel de
                        % generalizacion del modelo
                        perf(fold) = perform(net,Ytrain',net(Xtrain'));
                        % Estimacion de ECM para las muestras de validacion
                        ecm(fold) = immse(Yesti',Ytest);
                        % Esto es util para Sacar IC de eficiencia
                        eficiencia(fold) = sum(Yesti'==Ytest)/length(Ytest);
                        
                        % Muestro la gr�fica de la regresion
                        % plotregression(Ytrain',Yesti','Class');
                        
                        [Xroc,Yroc,~,AUC(fold)] = perfcurve(Ytest,score,'1');
                        plot(Xroc,Yroc);
                        title('Curva ROC');
                        xlabel('1 - Especificidad');
                        ylabel('Sensibilidad');
                        hold on;
                    end
                    disp(string('hidLaySize ') + hidLaySize + string(' epoch ') + epoch + string(' performance obtenido ') + mean(perf));
                    
                    IC1 = std(perf);
                    perf = mean(perf); 
                    Eficiencia = get(CP,'CorrectRate');
                    Error = get(CP,'ErrorRate');
                    Sensibilidad = get(CP,'Sensitivity');
                    Especificidad = get(CP,'Specificity');
                    Precision = get(CP,'PositivePredictiveValue'); %Precision
                    AUC = mean(AUC);
                    IC = std(eficiencia);
                    IC_ecm = std(ecm);
                    ecm = mean(ecm);
                    
                    
                    mallamedida(indEpoch+5*(indLayer-1)+15*(sel-1),:) = [ecm,IC_ecm,perf,IC1,Eficiencia,IC,Sensibilidad,Especificidad,Precision,AUC];
                    
                    disp(num2str(ecm));
                    disp(num2str(IC_ecm));
                    disp(num2str(perf));
                    disp(num2str(IC1));
                    disp(num2str(Eficiencia));
                    disp(num2str(IC));
                    disp(num2str(Sensibilidad));
                    disp(num2str(Especificidad));
                    disp(num2str(Precision));
                    disp(num2str(AUC));
                end
            end
        end
        
    case 4
        % Random Forest
    case 5
        % SVM
    otherwise
        disp('Opcion no valida, Saliendo...');
end

