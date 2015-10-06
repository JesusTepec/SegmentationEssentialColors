
Imagen = imread('fabric.png');
Imagen = rgb2lab(Imagen);
%Imagen = applycform(Imagen, makecform('srgb2lab'));
[h, w, p] = size(Imagen);
[PatronesImagen h, w]= CreaPatrones(Imagen);
[Clases, Centroides, SumDistancias, Distancias] = kkmeans(128, 8, PatronesImagen);

MatrizCentroides = AsignaCentroides(Clases, Centroides);
ImagenClases = CreaPatronesInv(h, w, MatrizCentroides);
%ImagenCalses = applycform(ImagenClases, makecform('lab2srgb'));
ImagenClases = double(ImagenClases);
ImagenClases = lab2rgb(ImagenClases);
figure, imshow(ImagenClases);
 
