close all
vectorImages = {'124084', '35070', '140075', '302003', '296059', '176035', '25098', '45096', '295087', '388016'};
Imagen = imread(strcat('../images/',vectorImages{2},'.jpg'));
figure, imshow(Imagen)
Imagen = rgb2lab(Imagen);

[h, w, p] = size(Imagen);
[PatronesImagen h, w]= CreaPatrones(Imagen);
k = 8;
ci = centinit(k, PatronesImagen);
[Clases, Centroides, SumDistancias, Distancias] = kmeans(PatronesImagen,...
    k,'MaxIter',1000,'Distance','city','Start', ci,'EmptyAction','singleton');
centroides = CalculaRegiones(Clases, Centroides, 5, k);
MatrizCentroides = AsignaCentroides(Clases, Centroides);
MatrizCentroides2 = AsignaCentroides(Clases, centroides);

ImagenClases = CreaPatronesInv(h, w, MatrizCentroides);
ImagenClases2 = CreaPatronesInv(h, w, MatrizCentroides2);

ImagenClases = double(ImagenClases);
ImagenClases = lab2rgb(ImagenClases);

ImagenClases2 = double(ImagenClases2);
ImagenClases2 = lab2rgb(ImagenClases2);

figure ,imshow(ImagenClases), title('K-means');
figure ,imshow(ImagenClases2), title('CIE');
 
%Ordenar el vector de clases, calcular la frecuencia de cada clase, colocar
%el vector de frecuencias junto con el vector de centroides, ordenar este
%ultimo de menor a mayor, Comparar los centroides de menor frecuencia con
%el resto de los centroides aderir este nuevo a la clase sea más parecida
%o de menor distancia, cumpliendo tambien con cierto valor de tolerancia en
%función de su distancia