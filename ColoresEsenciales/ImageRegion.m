
Imagen = imread('../images/65019.jpg');
figure, imshow(Imagen)
Imagen = rgb2lab(Imagen);

%Imagen = applycform(Imagen, makecform('srgb2lab'));
[h, w, p] = size(Imagen);
[PatronesImagen h, w]= CreaPatrones(Imagen);
k = 16;
ci = centinit(k, PatronesImagen);
[Clases, Centroides, SumDistancias, Distancias] = kmeans(PatronesImagen,...
    k,'MaxIter',1000,'Distance','city','Start', ci,'EmptyAction','singleton');

MatrizCentroides = AsignaCentroides(Clases, Centroides);
ImagenClases = CreaPatronesInv(h, w, MatrizCentroides);
%ImagenCalses = applycform(ImagenClases, makecform('lab2srgb'));
ImagenClases = double(ImagenClases);
ImagenClases = lab2rgb(ImagenClases);
figure, imshow(ImagenClases);
 
%Ordenar el vector de clases, calcular la frecuencia de cada clase, colocar
%el vector de frecuencias junto con el vector de centroides, ordenar este
%ultimo de menor a mayor, Comparar los centroides de menor frecuencia con
%el resto de los centroides aderir este nuevo a la clase sea más parecida
%o de menor distancia, cumpliendo tambien con cierto valor de tolerancia en
%función de su distancia