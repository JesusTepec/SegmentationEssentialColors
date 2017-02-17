function guardarResultados(imagenFinal, segmentos, imaS, datos, rutaGuardar, rutaInicial, imagenes, iter, u, fg1, fg2, tiempo)
    imStr = imagenes{iter};
    comparaciones = comparaSegmentos(imagenFinal, iter, imagenes, rutaInicial);
    imwrite(imagenFinal, [rutaGuardar, '\', imStr, num2str(iter), '.png']);
    imwrite(segmentos, [rutaGuardar, '\', imStr, num2str(iter), '-2', '.png']);
    imwrite(uint8(imaS), [rutaGuardar, '\', imStr, num2str(iter), '-ms', '.png']);
    saveas(fg1,[rutaGuardar, '\', imStr, num2str(iter), '-3'], 'png');
    saveas(fg2,[rutaGuardar, '\', imStr, num2str(iter), '-4'], 'png');
    fo = fopen([rutaGuardar,'\', imStr, '.txt'], 'w');
    fprintf(fo, '%s %f \n\r', 'Tolerancia:', datos(1));
    fprintf(fo, '%s %.0f \n\r', 'Centroides resultantes:', datos(2));
    fprintf(fo, '%s %s \r\n\n', 'Tiempo:', string(tiempo));
    colores = Array2StringArray(u, datos(2));
    fprintf(fo, '%s\r\n', colores);
    fprintf(fo, '%s\n\r', 'Comparaciones');
    for i=1:5
        fprintf(fo, '%f ', comparaciones(i));
    end
    fclose(fo);
end