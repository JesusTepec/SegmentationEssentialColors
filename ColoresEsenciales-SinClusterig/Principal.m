% Agrupamiento sin clustering inicial
close all
clear 
datetime
%% Number of Desired Colors, value of k
ANSWER = inputdlg('Number of desired colors for k means:','k means',1,{'16'});
k = str2double(ANSWER{1});
%% Load Image Data
   
originalImage = selectedImage();
image = imfilter(originalImage,fspecial('average',3));
%imageLab = rgb2lab(filtImage);
[h, w, p] = size(originalImage);

%% Get patterns of the image 
[t, u, i, c] = groupCount(CreaPatrones(image));
CentroidsKmeans = double(u(:,1:3));
disp('end of group uniques');
%% Tolerancia 
kurtosis = kurtosis(CentroidsKmeans(:))
dk = k;
if(kurtosis < 2)
    dk = k + 100;
end
threshold = (var(CentroidsKmeans(:)) / dk) 
t1 = 0.15;
if(threshold > 45)
   t1 = ((median(CentroidsKmeans(:)) / std(CentroidsKmeans(:)))+ kurtosis)
end
t2 = (threshold + kurtosis) / t1
%% Segmentation for patters recognition
resultColors = getImageRegion(c, double(u(:,1:3)), k, t);
disp('fin de recalculando centroides')
ImagenReconstruida = CreaPatronesInv(h, w, AsignaCentroides(c, resultColors));
imshow(ImagenReconstruida);
%% perimetros, rodear segmentos
[numeroColores, u, ~, ~] = groupCount(resultColors);
perimeters = imperim(ImagenReconstruida, uint8(u(:,1:3)), numeroColores);
segmentos = originalImage;
for i=1:numeroColores,
    segmentos = imoverlay(segmentos, perimeters(:, :, i), [.3 1 .3]);
end
%%
%ImagenFinal = lab2rgb(double(ImagenReconstruida));

y = double(im2uint8(ImagenReconstruida));
%% Show Results 
figure, imshow(segmentos); 
figure,
imshow(ImagenReconstruida); 
title(['Reduccion de colores (T = ' num2str(k) ') Reduccion a ' num2str(numeroColores) ' colores']);
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
title('Distribucion de pixeles después de Agrupar Colores')
xlim([0,255]),ylim([0,255]),zlim([0,255]);axis square
datetime