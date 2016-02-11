function  Centroides = CalculaRegiones(ClasesIniciales, Centroides, Tolerancia, k)
    Clases = sort(ClasesIniciales);
    Frecuencias = hist(Clases, k);
    datos = [Centroides, Frecuencias', (1:k)'];
    DatosOrdenados = sortrows(datos, 1); 
    i = 1;
    j = 2;
    while i < k
        Distancia = deltaE2000(DatosOrdenados(i, 1:3), DatosOrdenados(j, 1:3));
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


