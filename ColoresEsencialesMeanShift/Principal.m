close all
clear all
clc
rutaImagenes = 'C:\Users\Segmentación\Documents\MATLAB\SegmentationEssentialColors\Images';
rutaGuardar = 'C:\Users\Segmentación\Google Drive\Experimentos\fcm+DE+RGB';% cambiar carpeta por experimento
imagenes = {'113044.jpg', '225017.jpg', '385028.jpg', '388016.jpg', '35010.jpg', '24004.jpg', '295087.jpg', '176035.jpg', '181079.jpg', '296059.jpg', '124084.jpg', '163014.jpg', '101087.jpg', '35070.jpg', '42049.jpg', '253036.jpg', '45096.jpg', '60079.jpg', '135069.jpg', 'showimage.jpg', 'jouzawarusaidi1.jpg', 'descarga.png','test.jpg','DSC08913.jpg', 'cometa.jpg', 'micronuclueos.jpg'};
Nombres = {'113044', '225017', '385028', '388016', '35010', '24004', '295087', '176035', '181079', '296059', '124084', '163014', '101087', '35070', '42049', '253036', '45096', '60079', '135069', 'showimage', 'jouzawarusaidi1', 'descarga' , 'test', 'DSC08913', 'cometa', 'micronucleos'};
espacio = [1, 0, 0]; % [rgb, lab, hsv] no prender todos
clustering = [0, 1, 0, 1]; % [kmeans, fcm, meanshift, agrupamiento]
sleccionadas = [8 16 7 3 14 10 5 19 12 13];
k = 128                                                                                                                                                                                                                         ;
for iter = sleccionadas
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
        msim = CreaPatronesInv(h, w, AsignaCentroides(Clases, (Centroides)));
        disp('Saliendo de kmeans');
    elseif clustering(2)
        %% Convertir imagen a vector de patrones
        patrones = CreaPatrones(imagen);
        opts = [nan;nan;nan;0];
        [Centroides, U, ~] = fcm(double(patrones), k, opts);
        [~ ,Clases]= max(U);
        msim = CreaPatronesInv(h, w, AsignaCentroides(Clases, (Centroides)));
        disp('saliendo de fcm');
    elseif clustering(3)
        [msim, ~] = meanShiftPixCluster(double(imagen),20,32, 0.005, 0);
%         imshow(uint8(msim));
        disp('saliendo de meanshift');
        %% Convertir imagen a vector de patrones
%         if espacio(2)
%             msim2 = rgb2lab(msim);
%         elseif espacio(3)
%             msim2 = rgb2hsv(msim);
%         end
%         patrones = CreaPatrones(msim);
    end
    
    clear imagen
    if clustering(4)
%     if clustering(3)
%         initialCentroids = centinit(k, patrones);
%         [Clases, Centroides, ~, ~] = kmeans(double(patrones), k,'MaxIter', 200,'Distance', 'sqeuclidean', 'Start', initialCentroids,'EmptyAction','singleton');
%     end
        %% calcular valor de umbral para criterio de agrupamiento
        tolerancia = obtenerUmbral(Centroides, k, 1.5, 0.0005, 20);
    %    tolerancia = 9.562263;
        %% Agrupar colores algoritmo propuesto
        if espacio(1)
            [ColoresResultantes, nI]= getImageRegion(Clases, Centroides, tolerancia, k, 1);
            disp('fin de recalculando centroides RGB')
        elseif espacio(2)
            [ColoresResultantes, nI]= getImageRegion(Clases, Centroides, tolerancia, k, 1);
            disp('fin de recalculando centroides LAB')
        elseif espacio(3)
            [ColoresResultantes, nI]= getImageRegion(Clases, Centroides, tolerancia, k, 1);
            disp('fin de recalculando centroides HSV')
        end
    end
    
    %% Reconstruir imagen a partir de centroides y clases
    ImagenReconstruida = CreaPatronesInv(h, w, AsignaCentroides(Clases, (ColoresResultantes)));
     %Conversion
    if espacio(2)
        ColoresResultantes = lab2rgb(ColoresResultantes);
        figure, imshow(im2uint8(ImagenReconstruida))
        ImagenReconstruida = lab2rgb(double(ImagenReconstruida));
        msim = lab2rgb((msim));
    elseif espacio(3)
        ColoresResultantes = hsv2rgb(ColoresResultantes);
        figure, imshow(im2uint8(ImagenReconstruida))
        ImagenReconstruida = hsv2rgb(ImagenReconstruida);
        msim = hsv2rgb(msim);
    end
    %% obtenr unicos, perimetros, rodear segmentos
    [t, u, ~, c] = groupCount(uint8(ColoresResultantes));
    perimeters = imperim(uint8(ImagenReconstruida), u, t);
    segmentos = imagenOriginal;
    for i=1:t,
        segmentos = imoverlay(segmentos, perimeters(:, :, i), [.3 1 .3]);
    end
%     %%Resultados
     tiempoTotal = datetime - TiempoInicial;
    y = double(uint8(ImagenReconstruida));
    datos = [tolerancia, t, nI];
    [~, fg2] = showcharts(imagenOriginal,y);
    guardarResultados(uint8(ImagenReconstruida), segmentos, uint8(msim), datos, rutaGuardar, rutaImagenes, Nombres, iter, u, 0, fg2, tiempoTotal);
%     guardarResultados(uint8(msim), 0, 0, 0, rutaGuardar, rutaImagenes, Nombres, iter, 0, 0, 0, tiempoTotal);
    clear ImagenReconstruida TiempoInicial imagenOriginal imagen ColoresResultantes segmentos datos
   % close all
    disp(iter)
end