clc
clear all
close all

% Carga base de datos, tabla de X con atributos, tabla de Y con salidas
load('data_tab'); 


N = size(X,1); % Obtiene nro de filas de tabla
M = 4; % nro columnas a ser decodificadas

out = zeros(N,1); % matriz que guarda los valores recodificados de col X
props = X.Properties.VariableNames; % Toma los nombres de las columnas

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
                out(i,j)=1;
            case 'W'
                out(i,j)=2;
        end     
    end
end

%% One-hot encoding to column Shift, index 3 based on https://gist.github.com/zygmuntz/6939718
% Toma numero de categorias
n_categorias = size(    unique(X(:,3))     ,    1   );

% a vector of labels
shift_one_hot = zeros( size(X,1), n_categorias);

% assuming class labels start from one
for i = 1:n_categorias
    rows = out(:,3) == i;
    shift_one_hot( rows, i ) = 1;
end


% Organiza la matriz final  con las variables codificadas
full = [out(:,1:2),shift_one_hot,out(:,4),table2array(X(:,5:size(X,2)))]; %% Concatena las variables recodificadas con el resto de la tabla

disp('fin de decodificacion');


