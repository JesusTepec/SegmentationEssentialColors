close all
clear all
clc
rutaImagenes = 'C:\Users\Segmentación\Documents\MATLAB\SegmentationEssentialColors\Images';
rutaGuardar = 'C:\Users\Segmentación\Google Drive\Experimentos\Celulas';% cambiar carpeta por experimento
imagenes = {'113044.jpg', '225017.jpg', '385028.jpg', '388016.jpg', '35010.jpg', '24004.jpg', '295087.jpg', '176035.jpg', '181079.jpg', '296059.jpg', '124084.jpg', '163014.jpg', '101087.jpg', '35070.jpg', '42049.jpg', '253036.jpg', '45096.jpg', '60079.jpg', '135069.jpg', 'showimage.jpg', 'jouzawarusaidi1.jpg', 'descarga.png','test.jpg','DSC08913.jpg', 'cometa.jpg', 'micronuclueos.jpg'};
Nombres = {'113044', '225017', '385028', '388016', '35010', '24004', '295087', '176035', '181079', '296059', '124084', '163014', '101087', '35070', '42049', '253036', '45096', '60079', '135069', 'showimage', 'jouzawarusaidi1', 'descarga' , 'test', 'DSC08913', 'cometa', 'micronucleos'};
espacio = [0, 1, 0]; % [rgb, lab, hsv] no prender todos
clustering = [1, 0, 0, 1]; % [kmeans, fcm, meanshift, agrupamiento]
seleccionadas = [8 16 7 3 14 10 5 19 12 13];
%sleccionadas = [14 10 5 19 12 13];
% vectorK = [29	22	28	22	23	35	37	19	29	24	19	19	30	42	29	20	37	20	21];%hsv
% vectorK = [10	10	17	14	7	13	15	7	22	15	15	16	11	7	11	9 19	9	10];%lab
% vectorK = [7 10	64	57	16	24	98	11	90	66	69	53	26	8	16	7	80	3	5];%lab fcm
% vectorK = [11	8	9	10	6	11	10	4	9	9	7	9	7	11	10	7 6 10	6];% hsv fcm
% vectorK = [11	2	21	2	4	10	21	15	3	18	4	4	11	2	24	3 23	14	3]; %fcm rgb
% vectorK = [39	16	18	13	15	17	38	11	19	28	9	16	17	46	22	23	18	34	22]; %kmsrgb
k = 50;                                                                                                                                                                                                                         ;
for iter = 25 : 25
%      k = vectorK(iter)
    TiempoInicial = datetime
    %% Cargar image
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
        [msim, ~] = meanShiftPixCluster(double(imagen),25,32, 0.005, 0);
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
%   descomentar  
    clear imagen
    if clustering(4)
%     if clustering(3)
%         initialCentroids = centinit(k, patrones);
%         [Clases, Centroides, ~, ~] = kmeans(double(patrones), k,'MaxIter', 200,'Distance', 'sqeuclidean', 'Start', initialCentroids,'EmptyAction','singleton');
%     end
        %% calcular valor de umbral para criterio de agrupamiento
        tolerancia = obtenerUmbral(Centroides, k, 0.9, 0.0005, 14);
    %    tolerancia = 9.562263;
        %% Agrupar colores algoritmo propuesto
        if espacio(1)
            [ColoresResultantes, nI]= getImageRegion(Clases, Centroides, tolerancia, k, 3);
            disp('fin de recalculando centroides RGB')
        elseif espacio(2)
            [ColoresResultantes, nI]= getImageRegion(Clases, Centroides, tolerancia, k, 3);
            disp('fin de recalculando centroides LAB')
        elseif espacio(3)
            [ColoresResultantes, nI]= getImageRegion(Clases, Centroides, tolerancia, k, 3);
            disp('fin de recalculando centroides HSV')
        end
    else
        ColoresResultantes = Centroides;
        tolerancia = 0;
        nI = 2000;
    end
    
    %% Reconstruir imagen a partir de centroides y clases
    ImagenReconstruida = CreaPatronesInv(h, w, AsignaCentroides(Clases, (ColoresResultantes)));
     %Conversion
    if espacio(2)
        ColoresResultantes = lab2rgb(ColoresResultantes);
       % figure, imshow(im2uint8(ImagenReconstruida))
        ImagenReconstruida = lab2rgb(double(ImagenReconstruida));
        msim = lab2rgb((msim));
    elseif espacio(3)
        ColoresResultantes = hsv2rgb(ColoresResultantes);
        %figure, imshow(im2uint8(ImagenReconstruida))
        ImagenReconstruida = hsv2rgb(ImagenReconstruida);
        msim = hsv2rgb(msim);
    end
    %% obtenr unicos, perimetros, rodear segmentos
    [t, u, ~, c] = groupCount(im2uint8(ColoresResultantes));
    perimeters = imperim(im2uint8(ImagenReconstruida), u, t);
    segmentos = imagenOriginal;
    for i=1:t,
        segmentos = imoverlay(segmentos, perimeters(:, :, i), [.3 1 .3]);
    end
%     %%Resultados
      tiempoTotal = datetime - TiempoInicial;
    y = double(im2uint8(ImagenReconstruida));
    datos = [tolerancia, t, nI];
    [~, fg2] = showcharts(imagenOriginal,y);
    guardarResultados(im2uint8(ImagenReconstruida), segmentos, im2uint8(msim), datos, rutaGuardar, rutaImagenes, Nombres, iter, u, 0, fg2, tiempoTotal);
%%descomentar
%     guardarResultados(uint8(msim), 0, 0, 0, rutaGuardar, rutaImagenes, Nombres, iter, 0, 0, 0, tiempoTotal);
    clear ImagenReconstruida TiempoInicial imagenOriginal imagen ColoresResultantes segmentos datos
    close all
    disp(iter)
end