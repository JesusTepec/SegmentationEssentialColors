close all
clear all
clc
rutaImagenes = 'C:\Users\Segmentación\Documents\MATLAB\SegmentationEssentialColors\Images';
rutaGuardar = 'C:\Users\Segmentación\Google Drive\Experimentos\lab';% cambiar carpeta por experimento
imagenes = {'113044.jpg', '225017.jpg', '385028.jpg', '388016.jpg', '35010.jpg', '24004.jpg', '295087.jpg', '176035.jpg', '181079.jpg', '296059.jpg', '124084.jpg', '163014.jpg', '101087.jpg', '35070.jpg', '42049.jpg', '253036.jpg', '45096.jpg', '60079.jpg', '135069.jpg', 'showimage.jpg', 'jouzawarusaidi1.jpg', 'descarga.png','test.jpg','DSC08913.jpg', 'cometa.jpg', 'micronuclueos.jpg'};
Nombres = {'113044', '225017', '385028', '388016', '35010', '24004', '295087', '176035', '181079', '296059', '124084', '163014', '101087', '35070', '42049', '253036', '45096', '60079', '135069', 'showimage', 'jouzawarusaidi1', 'descarga' , 'test', 'DSC08913', 'cometa', 'micronucleos'};
espacio = [0, 1, 0]; % [rgb, lab, hsv] no prender todos
clustering = [0, 1, 0]; % [kmeans, fcm, meanshift]
k = 128                                                                                                                                                                                                                         ;
for iter = 1:19
    TiempoInicial = datetime
    %% Cargar imagne
    imagenOriginal =  imread([rutaImagenes, '\', imagenes{iter}]);
    [h, w, p] = size(imagenOriginal);
    imagen = imfilter(imagenOriginal,fspecial('average',3));
%     imagen = imagenOriginal;
    if clustering(3) == 0
        if espacio(2)
            imagen = rgb2lab(imagen);
        elseif espacio(3)
            imagen = rgb2hsv(imagen);
        end
    end 
    %% Clustering preagrupamiento de patrones
    msim = 0;
    if clustering(1)
        %% Convertir imagen a vector de patrones
        patrones = CreaPatrones(imagen);
        initialCentroids = centinit(k, patrones);
        [Clases, Centroides, ~, ~] = kmeans(double(patrones),k,'MaxIter', 1000,'Distance', 'sqeuclidean', 'Start', initialCentroids,'EmptyAction','singleton');
        disp('Saliendo de kmeans');
    elseif clustering(2)
        %% Convertir imagen a vector de patrones
        patrones = CreaPatrones(imagen);
        opts = [nan;nan;nan;0];
        [Centroides, U, ~] = fcm(double(patrones), k, opts);
        [~ ,Clases]= max(U);
    elseif clustering(3)
        [msim, ~] = meanShiftPixCluster(double(imagen),20,32, 0.0100, 0);
        disp('saliendo de meanshift');
        %% Convertir imagen a vector de patrones
        patrones = CreaPatrones(msim);
    end
    clear imagen
%     if clustering(3)
%         initialCentroids = centinit(k, patrones);
%         [Clases, Centroides, ~, ~] = kmeans(double(patrones), k,'MaxIter', 200,'Distance', 'sqeuclidean', 'Start', initialCentroids,'EmptyAction','singleton');
%     end
    %% calcular valor de umbral para criterio de agrupamiento
    tolerancia = obtenerUmbral(Centroides, k, 25, 0.0005, 1.1217);
%    tolerancia = 9.562263;
    %% Agrupar colores algoritmo propuesto
    if espacio(1)
        [ColoresResultantes, nI]= getImageRegion(Clases, Centroides, tolerancia, k, 3);
        disp('fin de recalculando centroides')
    elseif espacio(2)
        [k, Centroides, ~, Clases] = groupCount(patrones);
        [ColoresResultantes, nI]= getImageRegionLAB(Clases, Centroides, tolerancia, k, 1);
        disp('fin de recalculando centroides')
    elseif espacio(3)
        [ColoresResultantes, nI]= getImageRegionHSV(Clases, Centroides, tolerancia, k, 1);
        disp('fin de recalculando centroides')
    end
    
    %% Reconstruir imagen a partir de centroides y clases
    ImagenReconstruida = CreaPatronesInv(h, w, AsignaCentroides(Clases, (ColoresResultantes)));
     %%Conversion
    if espacio(2)
        ColoresResultantes = lab2rgb(ColoresResultantes);
        ImagenReconstruida = lab2rgb(double(ImagenReconstruida));
    elseif espacio(3)
        ColoresResultantes = hsv2rgb(ColoresResultantes);
        ImagenReconstruida = hsv2rgb(ImagenReconstruida);
    end
    %% obtenr unicos, perimetros, rodear segmentos
    [t, u, ~, c] = groupCount(im2uint8(ColoresResultantes));
    perimeters = imperim(im2uint8(ImagenReconstruida), u, t);
    segmentos = imagenOriginal;
    for i=1:t,
        segmentos = imoverlay(segmentos, perimeters(:, :, i), [.3 1 .3]);
    end
    %%Resultados
    tiempoTotal = datetime - TiempoInicial;
    y = double(im2uint8(ImagenReconstruida));
    datos = [tolerancia, t, nI];
    [~, fg2] = showcharts(imagenOriginal,y);
    guardarResultados(im2uint8(ImagenReconstruida), segmentos, msim, datos, rutaGuardar, rutaImagenes, Nombres, iter, u, 0, fg2, tiempoTotal);
    clear ImagenReconstruida TiempoInicial imagenOriginal imagen ColoresResultantes segmentos datos
    close all
    disp(iter)
end