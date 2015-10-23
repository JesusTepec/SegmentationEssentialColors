
function clases = CalculaRegiones(ClasesIniciales, Centroides, ValorTolerancia, k)
    Clases = sort(ClasesIniciales);
    Frecuencias = hist(Clases, k);
    DatosAgrupacion = [Frecuencias', Centroides];
    DatosOrdenados = sortrows(DatosAgrupacion, 1);
    [h,w] = size(DatosOrdenados);
  
%     P1 = repmat(DatosOrdenados(1,2:4),h,1);
%     P2 = DatosOrdenados(:,2:4);
%     D = deltaE2000(P1, P2);
%     disp(D');
    NuevasCleses = ClasesIniciales;
    NuevosCentroides = Centroides;
    disp(DatosOrdenados);
    D00 = deltaE2000(DatosOrdenados(1,2:4), DatosOrdenados(2,2:4));
    if(D00 < ValorTolerancia)
        P = (DatosOrdenados(1,2:4) + DatosOrdenados(2,2:4))/2;
        pos1 = find(1);
        pos2 = find(2);
        NuevosCentroides(1, 1:3) = P;
        NuevosCentroides(2, 1:3) = P;
    end
    disp(NuevosCentroides);
   clases = NuevasCleses; 
end