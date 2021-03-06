function  Centroides = getImageRegion(ClasesIniciales, Centroides, Tolerancia, k)
    Clases = sort(ClasesIniciales);
    Frecuencias = hist(Clases, k);
    datos = [Centroides, Frecuencias', (1:k)'];
    DatosOrdenados = sortrows(datos, 3); 
    i = 1;
    j = 2;
    while i < k
        S=mcovar(DatosOrdenados(:,1));
        Sinv = pinv(S);
        Distancia = (DatosOrdenados(i, 1) - DatosOrdenados(j, 1));
        Distancia = Distancia * Sinv * Distancia';
        if Distancia == 0
            i = i + 1;
            j = j + 1;
        elseif Distancia <= Tolerancia
            promedio = (DatosOrdenados(i, 1) + DatosOrdenados(j, 1)) / 2;
            DatosOrdenados(i, 1) = promedio;
            DatosOrdenados(j, 1) = promedio;
            frecuencia = DatosOrdenados(i, 2) + DatosOrdenados(j, 2); 
            DatosOrdenados = Cambiartodos(DatosOrdenados, promedio, frecuencia, j);
            DatosOrdenados(i, 2) = frecuencia;
            DatosOrdenados(j, 2) = frecuencia;
            DatosOrdenados = sortrows(DatosOrdenados, 2);
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
    Centroides = sortrows(DatosOrdenados, 3);
    Centroides = Centroides(:, 1);
end


function MatrizOrdenada = Ordenar(Matriz, NumeroColumna)
    MatrizOrdenada = sortrows(Matriz, NumeroColumna);
end



