%%
% Función Asigna Centroides
% MatrizCentroides = AsignaCentroides(Clases, Centroides)
%
% Asocia los centroides con las clases y devuelve una matriz de las mismas
% dimensiones que la Matriz de Patrones que se utilizo para agrupar con la
% funcion de kkmean.
% Clases: Vector de clases, se presenta como una matriz de una sola columna
% Centroides: Matriz de centroides
% MatrizCentroides: vector con centroides asociados a su clase
%%
function MatrizCentroides = AsignaCentroides(Clases, Centroides)
   % [RowClas, ColClas] = size(Clases);
   % [Row, Col] = size(Centroides);
  
%     for i = 1 : RowClas
%         for j = 1 : Row
%             if Clases(i) == j
%                 MatrizCentroides(i, :) = Centroides(j, :);
%             end
%         end
%     end
    n = length(Clases);
    MatrizCentroides = zeros(n, 3);
    for i=1:n
        MatrizCentroides(i,:) = Centroides(Clases(i),:);
    end 
end