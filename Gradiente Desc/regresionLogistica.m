function W = regresionLogistica(X,Y,eta)

[N,D]=size(X);
W = zeros(D,1);

for iter = 1:400
    %%% Completar el c�digo %%% 
     W = W - eta*(1/N)*((sigmoide((X*W))-Y)'*X)';
    %%% Fin de la modificaci�n %%%
end

end