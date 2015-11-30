close all
clear 

%% Select Image

Filter={'*.jpg;*.jpeg;*.png'};

[FileName, FilePath]=uigetfile(Filter);
pause(0.01);

if FileName==0
    return;
end

FullFileName=[FilePath FileName];
%% Number of Desired Colors

ANSWER = inputdlg('Number of desired colors:','Color Reduction',1,{'16'});
pause(0.01);

k = str2double(ANSWER{1});
%% Load Image Data
vectorImages = {'124084','35070',  '140075', '302003', '296059', '176035',...
                '25098', '242078', '45096',  '295087', '388016', '19021',...
                '2092',  '86000',  '293029', '65019',  '189003', '56028',...  
                '372047','test',   '60079',  '350 58',  '41004',  '41004-2',...
                '210088','3096',   'Plain',  'f4ce3'};
Imagen1 = imread(strcat(FullFileName));
%Imagen = rgb2lab(Imagen1);
Imagen = rgb2hsi(Imagen1);
figure, imshow(Imagen(:,:,1))
figure, imshow(Imagen(:,:,2))
figure, imshow(Imagen(:,:,3))

[h, w, p] = size(Imagen);
[PatronesImagen h, w]= CreaPatrones(Imagen);
PatronesImagen
ci = centinit(k, PatronesImagen);
  [Clases, Centroides, SumDistancias, Distancias] = kmeans(PatronesImagen,...
  k,'MaxIter',1000,'Distance', 'sqeuclidean', 'Start', ci,'EmptyAction','singleton');

%[Clases, Centroides] = kmeansexp(PatronesImagen, k);
%Dt = pdist(Centroides);
%prom = std(Dt)
Tolerancia = 0.12
disp('saliendo de kmeans');
centroides = CalculaRegiones(Clases, Centroides, Tolerancia, k);

disp('fin de recalculando centroides')
MatrizCentroides = AsignaCentroides(Clases, centroides);
ImagenClases = CreaPatronesInv(h, w, MatrizCentroides);

 M = AsignaCentroides(Clases, Centroides);
 I = CreaPatronesInv(h, w, M);

IC = double(I);
IC= hsi2rgb(IC);
ImagenClases = double(ImagenClases);
%ImagenClases = lab2rgb(ImagenClases);
ImagenClases = hsi2rgb(ImagenClases);
Imagen = hsi2rgb(Imagen);
%% Show Results
figure, imshow(Imagen)
figure;
subplot(1,2,1);
imshow(IC);
title('K-means');

subplot(1,2,2);
imshow(ImagenClases); 
title(['Color Reduced Image (T = ' num2str(Tolerancia) ') using euclidian and de2000' ]);


% a = bwperim(im2bw(ImagenClases, graythresh(rgb2gray(ImagenClases))));
% figure, imshow(a);
 
%Ordenar el vector de clases, calcular la frecuencia de cada clase, colocar
%el vector de frecuencias junto con el vector de centroides, ordenar este
%ultimo de menor a mayor, Comparar los centroides de menor frecuencia con
%el resto de los centroides aderir este nuevo a la clase sea más parecida
%o de menor distancia, cumpliendo tambien con cierto valor de tolerancia en
%función de su distancia
%Obtener el numero de colores finales agrupar iguales.