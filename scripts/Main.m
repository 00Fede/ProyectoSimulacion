%% Este Script contiene toda la lógica necesaria para hacer la prueba de
% los diferentes modelos de simulación en el data-set.
% Se asume que las variables fueron codificadas respectivamente y se hizo
% selección de variables previo.
punto=input('Seleccione:\n1 - Prueba de regresión logistica\n2 - GMM\n3 - Random Forest\n4 - RNA\n5 - SVM\n6 - k-vecinos\n7 - k-means\n8 - Arboles de decisión\n');



switch(punto)
    case 1
        %Regresion logistica
        
        W=regresionLogistica(Xtrain,Ytrain,eta); %%% Se obtienen los W coeficientes del polinomio
        
        Yesti=(W'*Xtest')';
        Yesti(Yesti>=0)=1;
        Yesti(Yesti<0)=0;
        
        Eficiencia=(sum(Yesti==Ytest))/length(Ytest);
        Error=1-Eficiencia;
        
        %     Texto=strcat('La eficiencia en prueba es: ',{' '},num2str(Eficiencia));
        Texto=['La eficiencia en prueba es: ',num2str(Eficiencia)];
        disp(Texto);
        %Texto=strcat('El error de clasificaci�n en prueba es: ',{' '},num2str(Error));
        Texto=['El error de clasificaci�n en prueba es: ',num2str(Error)];
        disp(Texto);
    case 2
        %GMM
    case 3
        %Random Forest
    case 4
        %RNA
    case 5
        %SVM
    case 6
        %k-vecinos
    case 7
        %k-means
    case 8
        %Arboles de decision
    otherwise
        disp('Opcion no valida, Saliendo...');
end

