close all
clear 

%% Select Image

Filter={'*.jpg;*.jpeg;*.png;*.tif'};

[FileName, FilePath]=uigetfile(Filter);
pause(0.01);

if FileName==0
    return;
end

FullFileName=[FilePath FileName];
% %% Number of Desired Colors

ANSWER = inputdlg('Number of desired colors:','Color Reduction',1,{'16'});
pause(0.01);

k = str2double(ANSWER{1});
%% Load Image Data
Imagen1 = imread(strcat(FullFileName));
x = Imagen1;
Imagen1=imfilter(Imagen1,fspecial('average',3));
%Imagen1 = cerradura(Imagen1, 1);
Imagen = rgb2lab(Imagen1);
%Imagen = Imagen1;
%% Reduction image
[h, w, p] = size(Imagen);
[PatronesImagen h, w]= CreaPatrones(Imagen);
 ci = centinit(k, PatronesImagen);
[Clases, Centroides, SumDistancias, Distancias] = kmeans(PatronesImagen,...
    k,'MaxIter',1000,'Distance', 'city', 'Start', ci,'EmptyAction','singleton');
%[Clases, Centroides, ~]= litekmeans(PatronesImagen, k)
a = var(Centroides(:))
Tolerancia = a / k + kurtosis(Centroides(:)) 
disp('saliendo de kmeans');
centroides = CalculaRegiones(Clases, Centroides, Tolerancia, k);
disp('fin de recalculando centroides')
MatrizCentroides = AsignaCentroides(Clases, centroides);
ImagenClases = CreaPatronesInv(h, w, MatrizCentroides);

 M = AsignaCentroides(Clases, Centroides);
 IC = CreaPatronesInv(h, w, M);
hg = ImagenClases;
IC = double(IC);
IC= lab2rgb(IC);
[Nc,~]= groupCount(centroides);
perimeters=imperim(hg,uint8(centroides), Nc);
    obj=x;
    for i=1:Nc,
        obj=imoverlay(obj,perimeters(:,:,i),[.3 1 .3]);
    end
    figure, imshow(obj);
ImagenClases = double(ImagenClases);
ImagenClases = lab2rgb(ImagenClases);
 y = double(im2uint8(ImagenClases));

%% Show Results  

figure;
subplot(1,2,1);
imshow(IC);
title([FileName '  K-means K = ' num2str(k) ' ']);

subplot(1,2,2);
imshow(ImagenClases); 
title(['Reduccion de colores (T = ' num2str(Tolerancia) ') Reduccion a ' num2str(Nc) ' colores']);
x = double (x);
     sample = zeros(size(x,1),size(x,2));
     sample(1:3:end,1:3:end) = 1;

     R = x(:,:,1); Rx = R(sample==1); Rn = randn( numel(Rx),1 )/3;
     G = x(:,:,2); Gx = G(sample==1); Gn = randn( numel(Rx),1 )/3;
     B = x(:,:,3); Bx = B(sample==1); Bn = randn( numel(Rx),1 )/3;
     
    
     figure, 
     subplot(221), imshow(uint8(x)), axis image; title('input image')
     subplot(223), imshow(obj), axis image; title('output image')
     subplot(222)
     scatter3( round(Rx(:)-Rn), round(Gx(:)-Gn),round( Bx(:)-Bn), 3, [ Rx(:), Gx(:), Bx(:) ]/255 );
     title('Pixel Distribution Before Meanshift')
     xlim([0,255]),ylim([0,255]),zlim([0,255]);axis square

     R = y(:,:,1); Ry = R(sample==1); Rn = randn( numel(Rx),1 )/3;
     G = y(:,:,2); Gy = G(sample==1); Gn = randn( numel(Rx),1 )/3;
     B = y(:,:,3); By = B(sample==1); Bn = randn( numel(Rx),1 )/3;
     subplot(224)
     scatter3( round(Ry(:)-Rn), round(Gy(:)-Gn), round(By(:)-Bn), 3, [ Rx(:), Gx(:), By(:) ]/255 );
     title('Pixel Distribution After Meanshift')
     xlim([0,255]),ylim([0,255]),zlim([0,255]);axis square

%%



 

