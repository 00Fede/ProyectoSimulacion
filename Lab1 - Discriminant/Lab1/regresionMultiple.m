function W = regresionMultiple(X,Y,eta)

[N,D]=size(X);
W=zeros(D,1);

for iter = 1:200
    %%% Completar el cï¿½digo %%% 
    %%%W = W - eta*(1/N)*((sigmoide(X'*W)'-Y)'*X); 
    %%W = W - eta*(1/N)*((sigmoide((X*W))-Y)'*X)';
   %%% W = W - eta*(1/N)*(((X*W)-Y)'*X)'
    %%% cuando es regresión múltiple no se usa sigmoide%%%
    W = W - eta*(1/N)*(((X*W)-Y)'*X)';
end

end