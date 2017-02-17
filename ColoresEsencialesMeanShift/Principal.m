close all
clear 
rutaImagenes = 'C:\Users\Segmentación\Documents\MATLAB\SegmentationEssentialColors\Images';
rutaGuardar = 'C:\Users\Segmentación\Google Drive\Experimentos\1';% cambiar carpeta por experimento
imagenes = {'113044.jpg', '225017.jpg', '385028.jpg', '388016.jpg', '35010.jpg', '24004.jpg', '295087.jpg', '176035.jpg', '181079.jpg', '296059.jpg', '124084.jpg', '163014.jpg', '101087.jpg', '35070.jpg', '42049.jpg', '253036.jpg', '45096.jpg', '60079.jpg', '135069.jpg', 'showimage.jpg', 'jouzawarusaidi1.jpg', 'descarga.png','test.jpg'};
Nombres = {'113044', '225017', '385028', '388016', '35010', '24004', '295087', '176035', '181079', '296059', '124084', '163014', '101087', '35070', '42049', '253036', '45096', '60079', '135069', 'showimage', 'jouzawarusaidi1', 'descarga' , 'test'};
espacio = [1, 0, 0]; % [rgb, lab, hsv] no prender todos
clustering = [1, 0, 0]; % [kmeans, fcm, meanshift]
k = 128;
for iter = 3:3
    TiempoInicial = datetime
    %% Cargar imagne
    imagenOriginal =  imread(strcat(rutaImagenes, '\', string(imagenes{iter})));
    [h, w, p] = size(imagenOriginal);
    imagen = imfilter(imagenOriginal,fspecial('average',3));
    if espacio(2)
        imagen = rgb2lab(imagen);
    elseif espacio(3)
        imagen = rgb2hsv(imagen);
    end
    %% Convertir imagen a vector de patrones
    patrones = CreaPatrones(imagen);
    %% Clustering preagrupamiento de patrones
    if clustering(1)
        initialCentroids = centinit(k, patrones);
        [Clases, Centroides, ~, ~] = kmeans(double(patrones),k,'MaxIter', 100,'Distance', 'sqeuclidean', 'Start', initialCentroids,'EmptyAction','singleton');
        disp('Saliendo de kmeans');
    elseif clustering(2)
    elseif clustering(3)
        [imagen, m] = meanShiftPixCluster(double(imagen),20,32, 0.2, 0);
        imaS = imagen;
        disp('saliendo de meanshift');
    end
    if clustering(3)
        initialCentroids = centinit(k, patrones);
        [Clases, Centroides, ~, ~] = kmeans(double(patrones), k,'MaxIter', 100,'Distance', 'sqeuclidean', 'Start', initialCentroids,'EmptyAction','singleton');
    end
    imaS = [6 7 8 9; 8 8 9 8];
    %% calcular valor de umbral para criterio de agrupamiento
    tolerancia = obtenerUmbral(Centroides, k, 0.3, 1.5) / 15;
    %% Agrupar colores algoritmo propuesto
    ColoresResultantes = getImageRegion(Clases, Centroides, tolerancia, k, 3);
    disp('fin de recalculando centroides')
    %% Reconstruir imagen a partir de centroides y clases
    ImagenReconstruida = CreaPatronesInv(h, w, AsignaCentroides(Clases, uint8(ColoresResultantes)));
    %% obtenr unicos, perimetros, rodear segmentos
    [t, u, ~, c] = groupCount(uint8(ColoresResultantes));
    perimeters = imperim(ImagenReconstruida, uint8(u), t);
    segmentos = imagenOriginal;
    for i=1:t,
        segmentos = imoverlay(segmentos, perimeters(:, :, i), [.3 1 .3]);
    end
    %%Conversion
    if espacio(2)
        ImagenReconstruida = lab2rgb(imagen);
    elseif espacio(3)
        ImagenReconstruida = hsv2rgb(imagen);
    end
    %%Resultados
    tiempoTotal = datetime - TiempoInicial;
    y = double(im2uint8(ImagenReconstruida));
    datos = [tolerancia, t];
    [fg1, fg2] = showcharts(imagenOriginal,y);
    guardarResultados(ImagenReconstruida, segmentos, imaS, datos, rutaGuardar, rutaImagenes, Nombres, iter, u, fg1, fg2, tiempoTotal);
    clear TiempoInicial imagenOriginal  ImagenReconstruida imagen
    close all
end