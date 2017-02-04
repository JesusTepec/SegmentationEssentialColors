function  Centroides = getImageRegion(ClasesIniciales, Centroides, Tolerancia, k)
%% Función de Agrupamiento
% Centroides = getImageRegion(ClasesIniciales, Centroides, Tolerancia, k)

% Agrupamiento de pixeles
% Vector de Clases
% Vector de Centroides [r, g, b]
% umbral de convergencia 
% Número de centroides de vector de centroides
% Autor: Jesús Tepec
%%
    Clases = sort(ClasesIniciales);
    Frecuencias = hist(Clases, k);
    datos = [Centroides, Frecuencias', (1:k)'];
    DatosOrdenados = sortrows(datos, 4); 
    i = 1;
    j = 2;
    I = 0;
    while  i < k

       %% Distance by DeltaE200        
        Distancia = deltaE2000(DatosOrdenados(i, 1:3), DatosOrdenados(j, 1:3));
       %% Distance euclidian
%       Distancia = DatosOrdenados(i, 1:3) - DatosOrdenados(j, 1:3);
       %% Mahalanobis
%         S = mcovar(DatosOrdenados(:,1:3));
%         Sinv = pinv(S);
%         min_diff = DatosOrdenados(i, 1:3) - DatosOrdenados(j, 1:3);        
%         Distancia = min_diff * Sinv * min_diff';
        %% 
        if Distancia == 0
            i = i + 1;
            j = j + 1;
        elseif Distancia <= Tolerancia
            promedio = (DatosOrdenados(i, 1:3) + DatosOrdenados(j, 1:3)) / 2;
            DatosOrdenados(i, 1:3) = promedio;
            DatosOrdenados(j, 1:3) = promedio;
            frecuencia = DatosOrdenados(i, 4) + DatosOrdenados(j, 4); 
            DatosOrdenados = Cambiartodos(DatosOrdenados, promedio, frecuencia, j);
            DatosOrdenados(i, 4) = frecuencia;
            DatosOrdenados(j, 4) = frecuencia;
            DatosOrdenados = sortrows(DatosOrdenados, 4);
            i = 1;
            j = 2;
        elseif Distancia > Tolerancia
            if j < k
                j = j + 1;
            else
                i = i + 1;
                j = i + 1;
            end
        end
    end
    Centroides = sortrows(DatosOrdenados, 5);
    Centroides = Centroides(:, 1:3);
end

function MatrizOrdenada = Ordenar(Matriz, NumeroColumna)
    MatrizOrdenada = sortrows(Matriz, NumeroColumna);
end


