
function centroidsMatrix = centroidClass(clases, centroids)
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
    n = length(clases);
    if(size(centroids, 2) == 1)
       [RowClas, ColClas] = size(clases);
       [Row, Col] = size(centroids);

        for i = 1 : RowClas
            for j = 1 : Row
                if clases(i) == j
                    centroidsMatrix(i, :) = centroids(j, :);
                end
            end
        end
    else
        centroidsMatrix = zeros(n, 3);
        for i = 1:n
            centroidsMatrix(i, :) = centroids(clases(i), :);
        end 
    end
end