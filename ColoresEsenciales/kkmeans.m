%% Uso: [class,centroids,sumD,distances]=kkmeans(k,d,x)
% 
% Esta función calcula el algoritmo k-means para una imagen x, usando
% patrones de dimensión d, para k clases.
% Obtendremos a qué clase (class) pertenece cada patrón, los centroides
% (centroids), la suma de las distancias para cada centroide (sumD), así
% como la matriz de distancias (distances). Utiliza la función externa
% "prek.m" creada ex-profeso por el autor, así como la función kmeans
% tradicional de Matlab.
% Autor: Ph.D. Antonio Alarcón Paredes 
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