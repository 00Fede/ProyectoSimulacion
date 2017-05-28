%% Este Script contiene toda la lógica necesaria para hacer la prueba de
% los diferentes modelos de simulación en el data-set.
% Se asume que las variables fueron codificadas respectivamente y se hizo
% selección de variables previo.
punto=input('Seleccione:\n1 - Funciones Discriminantes Gaussianas\n2 - K-vecinos\n3 - Redes Neuronales Artificiales\n4 - Random Forest\n5 - Maquinas de Soporte Vectorial\n');

load('data_mat_enc.mat'); %% Carga BD con variables codificadas


rept = 10;  % Numero de pliegues, repeticiones para cv
N = size(X,1); % Numero de muestras

switch(punto)
    case 1
        % Funciones Discriminantes Gaussianas
        X = X(:,[1:14,18,19]); % quitamos cols cuya var es 0
        eficiencia = zeros(1,rept); %vector fila para guardar eficiencia de c/fold
        for fold=1:rept
            
            rng('default');
            particion = cvpartition(N,'k',rept);  %genera validación cruzada
            Xtrain=X(particion.training(fold),:);
            Ytrain=Y(particion.training(fold));
            Xtest=X(particion.test(fold),:);
            Ytest=Y(particion.test(fold));
            
            % Genera el modelo con las muestra de entrenamiento
            model = fitcdiscr(Xtrain,Ytrain); 
            % hace prediccion de muestras de validacion
            Yesti = model.predict(Xtest);
            
            eficiencia(fold) = (sum(Yesti==Ytest)/length(Ytest));
        end
        
        Eficiencia = mean(eficiencia);
        IC = std(eficiencia);
        
        Text = ['La eficiencia obtenida de funciones discr. gauss. es ',num2str(Eficiencia),' +-',num2str(IC)];
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

