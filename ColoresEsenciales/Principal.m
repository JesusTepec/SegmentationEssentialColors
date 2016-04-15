% Kmeans con reagrupamiento 
close all
clear

%% Number of Desired Colors, value of k
ANSWER = inputdlg('Number of desired colors for k means:','k means',1,{'16'});
k = str2double(ANSWER{1});
%% Load Image Data
Filter={'*.jpg;*.jpeg;*.png;*.tiff'};
[FileName, FilePath]=uigetfile(Filter);
pause(0.01);
if FileName == 0
    return;
end
FullFileName=[FilePath FileName];


originalImage =  imread(strcat(FullFileName));
filtImage = imfilter(originalImage,fspecial('average',3));
%imageLab = rgb2lab(filtImage);
imageLab = filtImage;
[h, w, p] = size(originalImage);
%% Get patterns of the image 
imagePatterns = CreaPatrones(imageLab);
initialCentroids = centinit(k, imagePatterns);
%% Clustering of colors using k means
[ClasesKmeans, CentroidsKmeans, ~, ~] = kmeans(double(imagePatterns),...
k,'MaxIter',1000,'Distance', 'sqeuclidean', 'Start', initialCentroids,'EmptyAction','singleton');
%% Get parameters for the clustering with cuantification and  Segmentation
variance = var(CentroidsKmeans(:))
kurtosis = kurtosis(CentroidsKmeans(:))
mean = median(CentroidsKmeans(:))
threshold = (variance / k) + kurtosis

%% Segmentation for patters recognition
disp('saliendo de kmeans');
resultColors = getImageRegion(ClasesKmeans, CentroidsKmeans, 15, k);
disp('fin de recalculando centroides')
ImagenReconstruida = CreaPatronesInv(h, w, AsignaCentroides(ClasesKmeans, resultColors));
%%
%IC = CreaPatronesInv(h, w, AsignaCentroides(ClasesKmeans, CentroidsKmeans));
% IC = double(IC);
% IC = lab2rgb(IC);
%% perimetros, rodear segmentos
[t, u, i, c] = groupCount(resultColors);
figure, imshow(ImagenReconstruida);
[ClasesKmeans, CentroidsKmeans, ~, ~] = kmeans(double(imagePatterns),...
t,'MaxIter',1000,'Distance', 'sqeuclidean', 'Start', u(:,1:3),'EmptyAction','singleton');
IC = CreaPatronesInv(h, w, AsignaCentroides(ClasesKmeans, CentroidsKmeans));
figure,imshow(IC);
% perimeters = imperim(ImagenReconstruida, uint8(resultColors), numeroColores);
% segmentos = originalImage;
% for i=1:numeroColores,
%     segmentos = imoverlay(segmentos, perimeters(:, :, i), [.3 1 .3]);
% end
% %%
% %ImagenFinal = lab2rgb(double(ImagenReconstruida));
% ImagenFinal = ImagenReconstruida;
% y = double(im2uint8(ImagenFinal));
% %% Show Results 
% figure, imshow(segmentos); 
% figure;
% subplot(1,2,1);
% imshow(IC);
% title([FileName '  K-means K = ' num2str(k) ' ']);
% 
% subplot(1,2,2);
% imshow(ImagenFinal); 
% title(['Reduccion de colores (T = ' num2str(threshold) ') Reduccion a ' num2str(numeroColores) ' colores']);
% x = double (originalImage);
% sample = zeros(size(x,1),size(x,2));
% sample(1:3:end,1:3:end) = 1;
% 
% R = x(:,:,1); Rx = R(sample==1); Rn = randn( numel(Rx),1 )/3;
% G = x(:,:,2); Gx = G(sample==1); Gn = randn( numel(Rx),1 )/3;
% B = x(:,:,3); Bx = B(sample==1); Bn = randn( numel(Rx),1 )/3;   
%     
% figure, 
% subplot(121), imshow(uint8(x)), axis image; title('input image')
% subplot(122)
% scatter3( round(Rx(:)-Rn), round(Gx(:)-Gn),round( Bx(:)-Bn), 3, [ Rx(:), Gx(:), Bx(:) ]/255 );
% title('Distribucion de pixeles antes Agrupar Colores')
% xlim([0,255]),ylim([0,255]),zlim([0,255]);axis square
% figure, 
% subplot(121), imshow(segmentos), axis image; title('output image')
% R = y(:,:,1); Ry = R(sample==1); Rn = randn( numel(Rx),1 )/3;   
% G = y(:,:,2); Gy = G(sample==1); Gn = randn( numel(Rx),1 )/3;
% B = y(:,:,3); By = B(sample==1); Bn = randn( numel(Rx),1 )/3;
% subplot(122)
% scatter3( round(Ry(:)-Rn), round(Gy(:)-Gn), round(By(:)-Bn), 3, [ Rx(:), Gx(:), By(:) ]/255 );
% title('Distribucion de pixeles antes Agrupar Colores')
% xlim([0,255]),ylim([0,255]),zlim([0,255]);axis square
% imwrite(ImagenFinal, 'Reagrupig.jpg');
