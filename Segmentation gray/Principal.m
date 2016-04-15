% Métodos en escala de grises  
close all
clear
%% Select Image
Filter={'*.jpg;*.jpeg;*.png;*.tiff'};
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
originalImageRGB = imread(strcat(FullFileName));
originalImage = rgb2gray(originalImageRGB);
filtImage = imfilter(originalImage,fspecial('average',3));
[h, w, p] = size(originalImage);
%% Get patterns of the image 
imagePatterns = getPatterns(filtImage);
initialCentroids = centinit(k, imagePatterns);
%% Clustering of colors using k means
% [ClasesKmeans, CentroidsKmeans, ~, ~] = kmeans(double(imagePatterns),...
% k,'MaxIter',1000,'Distance', 'city','EmptyAction','singleton');
opts = [nan;nan;nan;0];
[CentroidsKmeans, U, ~] = fcm(imagePatterns, k, opts);
(var(CentroidsKmeans)/k)/100
U(: ,h * w + 1) = CentroidsKmeans(:,1);
U(: ,h * w + 1) = [];
[~ ,ClasesKmeans ]= max(U);
%Reclustering 
centroids = getImageRegion(ClasesKmeans, CentroidsKmeans, (var(CentroidsKmeans)/k)/100, k);
CentroidsKmeans = centroids;
%% reconstruction of the image
x = centroidClass(ClasesKmeans, CentroidsKmeans);
IC = getPixeles(h, w, x);

%% perimeters
[numeroColores, ~] = groupCount(CentroidsKmeans)
perimeters = imperim(IC, uint8(CentroidsKmeans), k);
imageRounded = originalImage;
for i=1:k,
    segmentos = imoverlay(imageRounded, perimeters(:, :, i), [.3 1 .3]);
end
% p = bwperim(im2bw(IC));
% r = originalImageRGB(:,:,1);
% g = originalImageRGB(:,:,2);
% b = originalImageRGB(:,:,3);
% r(p) = 0;
% g(p) = 255;
% b(p) = 0;
% SegoutRGB = cat(3, r, g, b);
%% Show Results
figure, imshow(segmentos);
figure;
subplot(1,2,1);
imshow(originalImage);
title([FileName ' Original Image']);
subplot(1,2,2);
imshow(IC); 
title(['Segmentation with k means k = ' num2str(k) ', without reclustering']);
