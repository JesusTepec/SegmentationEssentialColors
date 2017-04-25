function  [Centroides, I] = getImageRegion(ClasesIniciales, Centroides, Tolerancia, k, fnDistancia, espacio)
%% Función de Agrupamiento
% Centroides = getImageRegion(ClasesIniciales, Centroides, Tolerancia, k)

% Agrupamiento de pixeles
% Vector de Clases
% Vector de Centroides [r, g, b]
% umbral de convergencia 
% Número de centroides de vector de centroides
% fnDistancia: 1->DE2000, 2->euclidian, 3->mahalanobis
% Autor: Jesús Tepec
%%
%     [k, Centroides, ~, ClasesIniciales] = groupCount(Centroides);
%     whos Centroides ClasesIniciales k
    Clases = sort(ClasesIniciales);
    Frecuencias = hist(Clases, k);
    datos = [Centroides, Frecuencias', (1:k)'];
    DatosOrdenados = sortrows(datos, 4); 
    i = 1;
    j = 2;
    I = 0;
    while  i < k
        I = I + 1;
        %% Distance by DeltaE200 
        if fnDistancia == 1
          Distancia = deltaE2000(DatosOrdenados(i, 1:3), DatosOrdenados(j, 1:3));
        end
        %% Distance euclidian
        if fnDistancia == 2
          Distancia = sqrt((sum(DatosOrdenados(i, 1:3) - DatosOrdenados(j, 1:3)))^2);
        end
        %% Mahalanobis
        if fnDistancia == 3
           S = mcovar(DatosOrdenados(:,1:3));
           Sinv = pinv(S);
           min_diff = DatosOrdenados(i, 1:3) - DatosOrdenados(j, 1:3);        
           Distancia = min_diff * Sinv * min_diff';
        end
        %% 
        if Distancia == 0
            i = i + 1;
            j = j + 1;
%             disp('Iguanas');
        elseif Distancia <= Tolerancia
%             disp('menor');
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
%             disp('mayor')
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


