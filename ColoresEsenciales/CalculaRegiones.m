
function  Centroides = CalculaRegiones(ClasesIniciales, Centroides, Tolerancia, k)
    Clases = sort(ClasesIniciales);
    Frecuencias = hist(Clases, k);
    datos = [Centroides, Frecuencias', (1:k)'];
    DatosOrdenados = Ordenar(datos, 1);
    %Buscar la manera de controlar las iteraciones por medio de centinelas,
    %tal vez utilizando while, para qque no haya problema a la hora de
    %eliminar un elemento. hacer le ordenamiento otra vez. 
    i = 1;
    j = 2;
    while i < k
        Distancia = deltaE2000(DatosOrdenados(i, 1:3), DatosOrdenados(j, 1:3));
        if Distancia == 0
            i = i + 1;
            j = j + 1;
        elseif Distancia <= Tolerancia
                promedio = (DatosOrdenados(i, 1:3) + DatosOrdenados(j, 1:3))/2;
                DatosOrdenados(i, 1:3) = promedio;
                DatosOrdenados(j, 1:3) = promedio;
                frecuencia = DatosOrdenados(i, 4) + DatosOrdenados(j, 4); 
                DatosOrdenados = Cambiartodos(DatosOrdenados, promedio, frecuencia, j);
                DatosOrdenados(i, 4) = frecuencia;
                DatosOrdenados(j, 4) = frecuencia;
                DatosOrdenados = sortrows(DatosOrdenados, 4);
                i = 1;
                j = 2;
        %    end
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
                
                
%     while convergencia ~= 1
%         [h,~] = size(DatosOrdenados);
%         DatosOrdenados = Ordenar(DatosOrdenados, 1);
%         for i=1:h
%             Distancia = deltaE2000(DatosOrdenados(i, 2:4), DatosOrdenados(siguinte, 2:4));
%             if(Distancia < Tolerancia)
%                 disp(DatosOrdenados(i,2:4));
%                 disp(DatosOrdenados(siguinte, 2:4));
%                 promedio = (DatosOrdenados(i, 2:4) + DatosOrdenados(siguinte, 2:4))/2;
%                 NuevosCentroides(i,:) = promedio;
%                 NuevosCentroides(siguinte,:) = promedio;
%                 DatosOrdenados(i, :) = [];
%                 
%                 break;
%             else
%                 siguinte = siguinte + 1;
%             end
% 
%         end
%         if (cont == k || h <= Tolerancia) 
%             convergencia = 1;
%         end
%         cont = cont + 1;
%     end
           
%     for i=1:h 
%         for j=1:h
%             if i ~= j
%                 D(c) = deltaE2000(DatosOrdenados(i, 2:4), DatosOrdenados(j, 2:4));
%                 if(D(c) < ValorTolerancia)
%                     P = (DatosOrdenados(i, 2:4) + DatosOrdenados(j, 2:4)) / 2;
%                     NuevosCentroides(i, 1:3) = P;
%                     NuevosCentroides(j, 1:3) = P;
%                     DatosOrdenados(i,2:4) = [0];
%                     break;
%                 end                    
%                 c = c + 1;
%             end
%         end
%     end
    
%     NuevasCleses = ClasesIniciales;
%     NuevosCentroides = Centroides;
%     disp(DatosOrdenados);
%     D00 = deltaE2000(DatosOrdenados(1,2:4), DatosOrdenados(2,2:4));
%     if(D00 < ValorTolerancia)
%         P = (DatosOrdenados(1,2:4) + DatosOrdenados(2,2:4))/2;
%         pos1 = find(1);
%         pos2 = find(2);
%         NuevosCentroides(1, 1:3) = P;
%         NuevosCentroides(2, 1:3) = P;
%     end
%     disp(NuevosCentroides);
% [h,w] = size(DatosOrdenados);
%     disp(h);
%     disp(NuevosCentroides);
%    Centroides = NuevosCentroides;
end

function MatrizOrdenada = Ordenar(Matriz, NumeroColumna)
    MatrizOrdenada = sortrows(Matriz, NumeroColumna);
end

