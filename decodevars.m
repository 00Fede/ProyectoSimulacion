clc
clear all
close all

% Carga base de datos, tabla de X con atributos, tabla de Y con salidas
load('data_tab'); 


N = size(X,1); % Obtiene nro de filas de tabla
M = 4; % columna con la que se va a trabajar

out = zeros(N,1); % matriz que guarda los valores recodificados de col X
props = X.Properties.VariableNames; % Toma los 

for j=1:M
    % recorro los atributos a recodificar
for i=1:N
    % recorro cada fila del atributo j
    x = X.(props{j}){i}; % Toma caracter en variable j y fila i
    % empieza recodificacion
    switch x
        case 'a'
        out(i,j)=0;
        case 'b'
        out(i,j)=1;
        case 'c'
        out(i,j)=2;
        case 'd'
        out(i,j)=3;
        case 'N'
        out(i,j)=0;
        case 'W'
        out(i,j)=1;
    end     
end
end

full = [out,table2array(X(:,5:size(X,2)))]; %% Concatena las variables recodificadas con el resto de la tabla

disp('fin de decodificacion');


