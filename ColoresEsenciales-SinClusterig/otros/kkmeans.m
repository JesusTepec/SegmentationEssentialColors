%% Uso: [class,centroids,sumD,distances]=kkmeans(k,d,x)
% 
% Esta funci�n calcula el algoritmo k-means para una imagen x, usando
% patrones de dimensi�n d, para k clases.
% Obtendremos a qu� clase (class) pertenece cada patr�n, los centroides
% (centroids), la suma de las distancias para cada centroide (sumD), as�
% como la matriz de distancias (distances). Utiliza la funci�n externa
% "prek.m" creada ex-profeso por el autor, as� como la funci�n kmeans
% tradicional de Matlab.
% Autor: Ph.D. Antonio Alarc�n Paredes 
%%
    
function [class,centroids,sumD,distances]=kkmeans(k, d, varargin)
    
    Patrones = ParseInputs(varargin{:});

    Patrones = double(Patrones);
    ci = centinit(k, Patrones);
    [class, centroids, sumD, distances] = kmeans(Patrones, k,'MaxIter',1000,'Distance','city','Start',ci,'EmptyAction','singleton');

    function x = ParseInputs(varargin)
        x = varargin{1};
    end
end