% Kmeans con reagrupamiento -probando LAB con mahalanobis 65 para lab 15
% RGB


close all
clear
datetime

%% Number of Desired Colors, value of k
ANSWER = inputdlg('Number of desired colors for k means:','k means',1,{'16'});
k = str2double(ANSWER{1});
%% Load Image Data
    
Filter={'*.jpg;*.jpeg;*.png;*.tiff;*.tif'};
[FileName, FilePath] = uigetfile(Filter);
pause(0.01);
if FileName == 0
    return;
end
FullFileName=[FilePath FileName];

originalImage =  imread(strcat(FullFileName));
image = imfilter(originalImage,fspecial('average',3));
% image = rgb2lab(image);
[h, w, p] = size(image);
%% Get patterns of the image 
imagePatterns = CreaPatrones(image);
initialCentroids = centinit(k, imagePatterns);
%% Clustering of colors using k means
% [t, u, ~, ClasesKmeans] = groupCount(CreaPatrones(image));
% CentroidsKmeans = double(u(:,1:3));
% disp('end of group uniques');
%[ClasesKmeans, CentroidsKmeans, ~] = litekmeans(double(imagePatterns), k);
[ClasesKmeans, CentroidsKmeans, ~, ~] = kmeans(double(imagePatterns),...
k,'Distance', 'sqeuclidean', 'Start', initialCentroids,'EmptyAction','singleton');
%% Get parameters for the clustering with cuantification and  Segmentation
kurtosis = kurtosis(CentroidsKmeans(:))
threshold = (var(CentroidsKmeans(:)) / k) 
t1 = 0.16;
if(threshold > 35)
   t1 = ((median(CentroidsKmeans(:)) / std(CentroidsKmeans(:)))+ kurtosis)
end
t2 = (threshold + kurtosis) / t1
t2 = 26;
%% Segmentation for patters recognition
% disp('saliendo de kmeans');
datetime
imagePatterns = getImageRegion(ClasesKmeans, CentroidsKmeans, t2, t);
disp('fin de recalculando centroides')
ImagenReconstruida = CreaPatronesInv(h, w, AsignaCentroides(ClasesKmeans, uint8(imagePatterns)));
%%
%IC = CreaPatronesInv(h, w, AsignaCentroides(ClasesKmeans, CentroidsKmeans));
% IC = double(IC);
% IC = lab2rgb(IC);
%% perimetros, rodear segmentos
[t, u, i, c] = groupCount(uint8(imagePatterns));

perimeters = imperim(ImagenReconstruida, uint8(u(:,1:3)), t);
segmentos = originalImage;
for i=1:t,
    segmentos = imoverlay(segmentos, perimeters(:, :, i), [.3 1 .3]);
end
%%%
 labImage = ImagenReconstruida;
% ImagenReconstruida = lab2rgb(double(ImagenReconstruida));
%ImagenReconstruida = ImagenFinal;
y = double(im2uint8(ImagenReconstruida));
%% Show Results 
figure, imshow(segmentos); 
% figure;
% subplot(1,2,1);
% imshow(IC);
% title([FileName '  K-means K = ' num2str(k) ' ']);
% 
% subplot(1,2,2);
figure, imshow(ImagenReconstruida); 
title(['Reduccion de colores (T = ' num2str(t2) ') Reduccion a ' num2str(t) ' colores']);
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
title('Distribucion de pixeles antes de Agrupar Colores')
xlim([0,255]),ylim([0,255]),zlim([0,255]);axis square
figure, 
subplot(121), imshow(segmentos), axis image; title('output image')
R = y(:,:,1); Ry = R(sample==1); Rn = randn( numel(Rx),1 )/3;   
G = y(:,:,2); Gy = G(sample==1); Gn = randn( numel(Rx),1 )/3;
B = y(:,:,3); By = B(sample==1); Bn = randn( numel(Rx),1 )/3;
subplot(122)
    scatter3( round(Ry(:)-Rn), round(Gy(:)-Gn), round(By(:)-Bn), 3, [ Rx(:), Gx(:), By(:) ]/255 );
title('Distribucion de pixeles después de Agrupar Colores')
xlim([0,255]),ylim([0,255]),zlim([0,255]);axis square
datetime
