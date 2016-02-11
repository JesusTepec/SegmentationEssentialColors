function matriz = Cambiartodos(matriz, prom, frec, j)
	[filas,~] = size(matriz);
	for i = j + 1 : filas,
	    if matriz(i, 1:3) == matriz(j, 1:3),
	        matriz(i, 1:3) = prom;
	        matriz(i, 4) = frec;
	    end
	end
end