% Imagen(:,:,1) = [5 45 45 45; 123 59 45 47; 58 213 25 36; 78 51 16 28];
% Imagen(:,:,2) = [45 45 3 45; 123 89 45 47; 158 23 25 36; 78 45 16 28];
% Imagen(:,:,3) = [5 45 54 45; 123 59 45 47; 58 213 25 36; 78 45 56 28];

Imagen = imread('fabric.png');
%Imagen = rgb2lab(Imagen);
Imagen = applycform(Imagen, makecform('srgb2lab'));
[h, w, p] = size(Imagen);

ImagenAuxiliar = padarray(Imagen, [1 1]);
%ImagenAuxiliar = double(ImagenAuxiliar);
InicioY = 2;
InicioX = 2;
cont = 0;
for i = InicioY - 1:InicioY + 1
    for j=InicioX - 1:InicioX + 1
        P1 = ImagenAuxiliar(2,2,1:3);
        P2 = ImagenAuxiliar(i,j,1:3);
        Distancia = 0;
        Distancia = CIE2000(P1, P2);
     %   disp(P2);
      %  fprintf('%d %d\n', i, j);
       disp(Distancia);
%        
        if Distancia <= 36
            cont = cont + 1;
            
        end
    end
end
cont