
function  Centroides = CalculaRegiones(ClasesIniciales, Centroides, ValorTolerancia, k)
    Clases = sort(ClasesIniciales);
    Frecuencias = hist(Clases, k);
    DatosAgrupacion = [Frecuencias', Centroides];
    DatosOrdenados = sortrows(DatosAgrupacion, 1);
    [h,w] = size(DatosOrdenados);
  
%     P1 = repmat(DatosOrdenados(1,2:4),h,1);
%     P2 = DatosOrdenados(:,2:4);
%     D = deltaE2000(P1, P2);
%     disp(D');
    c = 1;
    NuevosCentroides = Centroides;
    for i=1:h
        for j=1:h
            if i ~= j
                D(c) = deltaE2000(DatosOrdenados(i, 2:4), DatosOrdenados(j, 2:4));
                if(D(c) < ValorTolerancia)
                    P = (DatosOrdenados(i, 2:4) + DatosOrdenados(j, 2:4)) / 2;
                    NuevosCentroides(i, 1:3) = P;
                    NuevosCentroides(j, 1:3) = P;
                    break;
                end                    
                c = c + 1;
            end
        end
    end
    
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
   Centroides = NuevosCentroides;
end