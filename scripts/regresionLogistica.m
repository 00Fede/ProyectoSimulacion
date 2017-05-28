% Esta funcion es casi identica a: "regresionMultiple.m" la unica
% diferencia es que una vez calculada F(X) (O sea: X*W), la matriz
% resultante pasa por la funcion sigmoide para determinar a que clase
% asignar las muestras.
function W = regresionLogistica(X,Y,eta)

[N,D]=size(X);
W = zeros(D,1);

for iter = 1:100
    %%% Completar el código %%% 
    
    W = W - eta*(1/N)*((sigmoide((X*W))-Y)'*X)';
    
    % [Opcional] Para graficar la frontera de separacion se hace:
    
    %X1 = X(Y==0, 1:2);
    %X2 = X(Y==1, 1:2);
    X1 = X(Y==0, 1:2).^2;
    X2 = X(Y==1, 1:2).^2;
    plot(X1(:,1), X1(:,2), 'xr')
    hold on
    plot(X2(:,1), X2(:,2), '+b')
    
    X1 = linspace( min(X(:,1)), max(X(:,2)), 4 );
    Yaux = X1*(W(1)/W(2)) - W(3)/W(2);
    plot(X1, Yaux, 'k')
    hold off
    
    % Por ultimo le damos una pausa antes de pasar a la siguiente iteracion para poder visualizar bien cada trazado de la frontera
    pause(0.1) 
    
    %%% Fin de la modificación %%%
end

end