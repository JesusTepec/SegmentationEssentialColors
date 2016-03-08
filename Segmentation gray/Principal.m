% Segmentacion k means, sin reagrupamiento
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
originalImage = rgb2gray(originalImage);
whos originalImage;
filtImage = imfilter(originalImage,fspecial('average',3));
[h, w, p] = size(originalImage);
%% Get patterns of the image 
imagePatterns = getPatterns(filtImage);
initialCentroids = centinit(k, imagePatterns);
%% Clustering of colors using k means
[ClasesKmeans, CentroidsKmeans, ~, ~] = kmeans(double(imagePatterns),...
k,'MaxIter',1000,'Distance', 'city','EmptyAction','singleton');
%% reconstruction of the image
x = centroidClass(ClasesKmeans, CentroidsKmeans);
IC = getPixeles(h, w, x);

%% perimeters
perimeters = imperim(IC, uint8(CentroidsKmeans), k);
imageRounded = originalImage;
for i=1:k,
    segmentos = imoverlay(imageRounded, perimeters(:, :, i), [.3 1 .3]);
end
%% Show Results 
figure, imshow(segmentos); 

figure;
subplot(1,2,1);
imshow(originalImage);
title([FileName ' Original Image']);
subplot(1,2,2);
imshow(IC); 
title(['Segmentation with k means k = ' num2str(k) ', without reclustering']);
