function Yesti = vecinosCercanos(Xval,Xent,Yent,k,tipo)

    %%% El parametro 'tipo' es el tipo de problema que se va a resolver
    
    %%% La función debe retornar el valor de predicción Yesti para cada una de 
    %%% las muestras en Xval. Por esa razón Yesti se inicializa como un vectores 
    %%% de ceros, de dimensión M.

    N=size(Xent,1); % N = Numero de muestras de entrenamiento
    M=size(Xval,1); % M = Numero de muestras para la validacion
    
    Yesti=zeros(M,1);
    dis=zeros(N,M);  % Primero tenia (N,1) dimensiones y mejor le puse (N,M) dimensiones
    
    % >>>>>>>>> 2º Aqui se calcula las distancias para saber la separacion de todo con todos
    dis = repmat(sum(Xent.^2,2),1,M) + repmat(sum(Xval.^2,2)',N,1) - 2*(Xent*Xval');
    dis = sqrt(dis);
    % Para entender plenamente como calculo todas las distancias con solo
    % estas pocas instrucciones vease el archivo: estrategiakvecinos[Distancias].pdf
    % Alli desgloso cada una de las partes de estas instrucciones.
    
     % >>>>>>>>> 3º Determino los vecinos
     
     % ============ Nota ============
     % Transpongo la matriz dis antes de ordenarla porque
     % así en cada fila me quedaran las distancias de cada
     % muestra  de validacion con respecto a las muestras
     % de cada una de las muestras de entrenamiento.
     % Por ejemplo:
     %
     % La celda fila1Xcolumna1 sera la distancia de la
     % muestra de validacion 1 con respecto a la muestra
     % de entrenamiento 1.
     %
     % La celda fila1Xcolumna2 sera la distancia de la
     % muestra de validacion 1 con respecto a la muestra
     % de entrenamiento 2.
     % 
     % Y así sucesivamente.
     %
     % Esto es necesario porque a final de cuentas yo tengo es que entregar
     % la prediccion en base a mis muestras de validacion.
     % ============== ==============
     
     % Entonces, primero ordeno de menor a mayor los contenidos de cada
     % fila, o sea cual son las distancias mas cercanas a cada muestra de
     % validacion. Y en el retorno me debe devolver el arreglo ordenado
     % pero tal resultado o matriz la descarto, no obstante el segundo
     % elemento que me devuelve si me interesa y son los
     % indices ordenados de la matrix por valor (Dicha matrix de indices 
     % debe tener las dimensiones (N,M))
     [~, indices] = sort(dis', 2); 
     % Ya con una matriz de indices que esta ordenada de menor a mayor
     % de acuerdo al valor, entonces tomare todas las filas de dicha matriz
     % pero solo las primera K columnas. Donde K seran los K más
     % cercanos para cada muestra de validacion.
     indices = indices(:, 1:k);
     
     
    % >>>>>>>>> 4º Por ultimo, calculo el Y*
    % ============ Nota ============
    % Los ciclos no los necesito porque como calculo de todo y por
    % todas las distancias entonces al final no requiero iterar
    % por cada una de las muestras de validacion sino que se hace
    % en una sola instruccion.
    % ============== ==============
    % Por ultimo e independiente de si se va por la condicion de
    % clasificacion o de regresion, ya con la matriz de indices puedo
    % hacer una matriz de igual dimensiones (o sea, de 309xK) donde
    % cada uno de los elementos de dicha matrix son tomadas de Yent
    % en las posiciones indicadas por indices.
    %
    % Para mayor claridad, tan solo descomente la seccion:
    % section prueba en main.m (punto 3)
    %
    % y comente en main.m:
    % Yesti=vecinosCercanos(Xtest,Xtrain,Ytrain,k,'regress');
    %
    % Luego ponga a correr el script y una vez aparezca la salida en el
    % command window, pasese a ver el contenido de las variables:
    %               indices    temp    Ytrain   Yesti
    %
    % Estoy seguro que si las observa con atencion se dara cuanta de como
    % se seleccionan los datos
    if strcmp(tipo,'class') % Para clasificación

        %for j=1:M 
            %%% Complete el codigo %%%
            
            Yesti = mode(Yent(indices), 2); % Aqui se calcula la moda por filas y se retorna como Yestimada
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%
            
        %end
    elseif strcmp(tipo,'regress') % Para regresion
        
        %for j=1:M
            %%% Complete el codigo %%%
            
            Yesti = mean(Yent(indices), 2); % Aqui se calcula la media por filas y se retorna como Yestimada
            
			%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %end
    end
end