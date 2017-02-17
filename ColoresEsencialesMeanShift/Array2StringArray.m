function textArray = Array2StringArray(matriz, t)
%     matriz = im2uint8(lab2rgb(double(matriz(:, 1:3))));
%     matriz = (matriz(:, 1:3));
    matriz = sortrows(matriz, 1);
    matriz = sortrows(matriz, 2);
    matriz = sortrows(matriz, 3);
    i = 1;
    textArray = '';
    while i <= t
%         disp( strcat('[', num2str(matriz(i,1)), ', ',num2str(matriz(i,2)), ', ', num2str(matriz(i,3)), '],'));
        aux = strcat('[', num2str(matriz(i,1)), ', ',num2str(matriz(i,2)), ', ', num2str(matriz(i,3)), '],');
        textArray = strcat(textArray, aux);
        i = i + 1;
    end 
end