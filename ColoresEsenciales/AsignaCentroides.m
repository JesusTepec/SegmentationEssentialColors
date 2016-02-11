
function MatrizCentroides = AsignaCentroides(Clases, Centroides)
%%
% Función AsignaCentroides
% MatrizCentroides = AsignaCentroides(Clases, Centroides)
%
% Asocia los centroides con las clases y devuelve una matriz de las mismas
% dimensiones que la Matriz de Patrones que se utilizo para agrupar con la
% funcion de kkmean.
% input Clases: Vector de clases, se presenta como una matriz de una sola columna
% input Centroides: Matriz de centroides
%
% output MatrizCentroides: vector con centroides asociados a su clase
%

    n = length(Clases);
    MatrizCentroides = zeros(n, 3);
    for i = 1:n
        MatrizCentroides(i, :) = Centroides(Clases(i), :);
    end 
end