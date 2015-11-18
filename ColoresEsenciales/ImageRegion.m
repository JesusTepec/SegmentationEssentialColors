close all
clear 
vectorImages = {'124084', '35070', '140075', '302003', '296059', '176035', '25098',...
    '242078', '45096', '295087', '388016', '19021', '2092', '86000', '293029', '41004', ...
    '65019', '189003', '56028', '372047', 'test'};
% Imagen = imread(strcat('../images/',vectorImages{1},'.jpg'));
Imagen = imread('fabric.png');
figure, imshow(Imagen)
Imagen = rgb2lab(Imagen);

[h, w, p] = size(Imagen);
[PatronesImagen h, w]= CreaPatrones(Imagen);
k = 32;
ci = centinit(k, PatronesImagen);
[Clases, Centroides, SumDistancias, Distancias] = kmeans(PatronesImagen,...
    k,'MaxIter',1000,'Distance', 'city', 'Start', ci,'EmptyAction','singleton');
d = pdist(Centroides,'cityblock');
tol = std(Distancias(:))
% tol = std(Distancias(:));
centroides = CalculaRegiones(Clases, Centroides, 18, k);
MatrizCentroides = AsignaCentroides(Clases, centroides);
ImagenClases = CreaPatronesInv(h, w, MatrizCentroides);

i = ImagenClases;

ImagenClases = double(ImagenClases);
ImagenClases = lab2rgb(ImagenClases);

%figure ,imshow(ImagenClases), title('RGB');
figure ,imshow(ImagenClases), title('LAB');
a = bwperim(im2bw(ImagenClases));
figure, imshow(a);
 
%Ordenar el vector de clases, calcular la frecuencia de cada clase, colocar
%el vector de frecuencias junto con el vector de centroides, ordenar este
%ultimo de menor a mayor, Comparar los centroides de menor frecuencia con
%el resto de los centroides aderir este nuevo a la clase sea m�s parecida
%o de menor distancia, cumpliendo tambien con cierto valor de tolerancia en
%funci�n de su distancia