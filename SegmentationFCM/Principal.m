% fcm
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
%% Load Image Data
originalImage = imread(strcat(FullFileName));
filtImage = imfilter(originalImage,fspecial('average',3));
imageLab = rgb2lab(filtImage);
[h, w, p] = size(originalImage);
%% Get patterns of the image 
imagePatterns = getPatterns(imageLab);
initialCentroids = centinit(k, imagePatterns);
%% Clustering of colors using k means
opts = [nan;nan;nan;0];
[CentroidsKmeans, U, ~] = fcm(double(imagePatterns), k, opts);
% U(: ,h * w + 1) = CentroidsKmeans(:,1);
% U = sortrows(U, h * w + 1);
% U(: ,h * w + 1) = [];
[~ ,ClasesKmeans ]= max(U);
%% reconstruction of the image
IC = getPixeles(h, w, AsignaCentroides(ClasesKmeans, CentroidsKmeans));
k
%% perimeters
perimeters = imperim(IC, uint8(CentroidsKmeans), k);
imageRounded = originalImage;
for i=1:k,
    segmentos = imoverlay(imageRounded, perimeters(:, :, i), [.3 1 .3]);
end
%% return to RGB
IC = double(IC);
IC = lab2rgb(IC);
%% Show Results 
figure, imshow(segmentos); 
y = double(im2uint8(IC));
figure;
subplot(1,2,1);
imshow(originalImage);
title([FileName ' Original Image']);
subplot(1,2,2);
imshow(IC); 
title(['Segmentation with k means k = ' num2str(k) ', without reclustering']);
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
subplot(121), imshow(IC), axis image; title('output image')
R = y(:,:,1); Ry = R(sample==1); Rn = randn( numel(Rx),1 )/3;
G = y(:,:,2); Gy = G(sample==1); Gn = randn( numel(Rx),1 )/3;
B = y(:,:,3); By = B(sample==1); Bn = randn( numel(Rx),1 )/3;
subplot(122)
scatter3( round(Ry(:)-Rn), round(Gy(:)-Gn), round(By(:)-Bn), 3, [ Rx(:), Gx(:), By(:) ]/255 );
title('Distribucion de pixeles antes Agrupar Colores')
xlim([0,255]),ylim([0,255]),zlim([0,255]);axis square
imwrite(IC, 'Reagrupig2.jpg');
