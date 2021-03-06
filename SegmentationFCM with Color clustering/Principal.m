% fcm con reagrupamiento
close all
clear
%% Select Image
Filter={'*.jpg;*.jpeg;*.png;*.tif'};
[FileName, FilePath]=uigetfile(Filter);
pause(0.01);
if FileName == 0
    return;
end
FullFileName=[FilePath FileName];
%% Number of Desired Colors, value of k
ANSWER = inputdlg('Number of desired colors for k means:','k means',1,{'16'});
k = str2double(ANSWER{1});
datetime
%% Load Image Data
originalImage = imread(strcat(FullFileName));
filtImage = imfilter(originalImage,fspecial('average',3));
% imageLab = rgb2lab(filtImage);
imageLab = rgb2hsv(filtImage);
[h, w, p] = size(originalImage);
% imageLab = double(originalImage);
%% Get patterns of the image 
imagePatterns = getPatterns(imageLab);
initialCentroids = centinit(k, imagePatterns);
%% Clustering of colors using k means
opts = [nan;nan;nan;0];
[CentroidsKmeans, U, ~] = fcm(imagePatterns, k, opts);
U(: ,h * w + 1) = CentroidsKmeans(:,1);
U(: ,h * w + 1) = [];
[~ ,ClasesKmeans ]= max(U);
%% Get parameters for the clustering with cuantification and  Segmentation
kurtosis = kurtosis(CentroidsKmeans(:))
dk = k;
if(kurtosis < 2)
    dk = k + 100;
end
threshold = (var(CentroidsKmeans(:)) / dk) 
t1 = 1;
if(threshold > 25)
   t1 = ((median(CentroidsKmeans(:)) / std(CentroidsKmeans(:)))+ kurtosis)
end
t2 = (threshold + kurtosis) / t1

threshold = t2 / 4
%% Segmentation for patters recognition
disp('saliendo de fcm');
resultColors = getImageRegion(ClasesKmeans, CentroidsKmeans, threshold, k);
disp('fin de recalculando centroides')
resultColors = hsv2rgb(resultColors);
ImagenReconstruida = CreaPatronesInv(h, w, AsignaCentroides(ClasesKmeans, im2uint8(resultColors)));

%% perimetros, rodear segmentos
[numeroColores, u] = groupCount(resultColors);
%[numeroColores, u] = groupCount(im2uint8(lab2rgb(resultColors))); %lab

%perimeters = imperim(ImagenReconstruida,uint8(rgb2lab(u(:,1:3))), numeroColores);
% perimeters = imperim(ImagenReconstruida,uint8(u(:,1:3)), numeroColores);
perimeters = imperim(ImagenReconstruida,im2uint8(u(:,1:3)), numeroColores);
segmentos = originalImage;
for i=1:numeroColores,
    segmentos = imoverlay(segmentos, perimeters(:, :, i), [.3 1 .3]);
end
% %%
%   ImagenReconstruida = lab2rgb(double(ImagenReconstruida));

% ImagenReconstruida = hsv2rgb(double(ImagenReconstruida));
y = double(im2uint8(ImagenReconstruida));
%% RGB
% y = double(ImagenReconstruida);

%% Show Results 
figure, imshow(segmentos); 
figure,
imshow(im2uint8(ImagenReconstruida)); 
title(['Reduccion de colores (T = ' num2str(threshold) ') Reduccion a ' num2str(numeroColores) ' colores']);
x = double (originalImage);
sample = zeros(size(x,1),size(x,2));
sample(1:3:end,1:3:end) = 1;

R = x(:,:,1); Rx = R(sample==1); Rn = randn( numel(Rx),1 )/3;
G = x(:,:,2); Gx = G(sample==1); Gn = randn( numel(Rx),1 )/3;
B = x(:,:,3); Bx = B(sample==1); Bn = randn( numel(Rx),1 )/3;   
    
figure, 
subplot(121), imshow(uint8(x)), axis image; title('input image')
subplot(122)
scatter3( round(Rx(:)-Rn), round(Gx(:)-Gn),round( Bx(:)-Bn), 3, [ Rx(:), Gx(:), Bx(:) ]/255 );
title('Distribucion de pixeles antes Agrupar Colores')
xlim([0,255]),ylim([0,255]),zlim([0,255]);axis square
figure, 
subplot(121), imshow(segmentos), axis image; title('output image')
R = y(:,:,1); Ry = R(sample==1); Rn = randn( numel(Rx),1 )/3;
G = y(:,:,2); Gy = G(sample==1); Gn = randn( numel(Rx),1 )/3;
B = y(:,:,3); By = B(sample==1); Bn = randn( numel(Rx),1 )/3;
subplot(122)
scatter3( round(Ry(:)-Rn), round(Gy(:)-Gn), round(By(:)-Bn), 3, [ Rx(:), Gx(:), By(:) ]/255 );
title('Distribucion de pixeles despu�s de Agrupar Colores')
xlim([0,255]),ylim([0,255]),zlim([0,255]);axis square
datetime