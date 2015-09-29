% Imagen(:,:,1) = [5 45 45 45; 123 59 45 47; 58 213 25 36; 78 51 16 28];
% Imagen(:,:,2) = [45 45 3 45; 123 89 45 47; 158 23 25 36; 78 45 16 28];
% Imagen(:,:,3) = [5 45 54 45; 123 59 45 47; 58 213 25 36; 78 45 56 28];

Imagen = imread('../Images/76053.jpg');
%Imagen = rgb2lab(Imagen);
Imagen = applycform(Imagen, makecform('srgb2lab'));
[h, w, p] = size(Imagen);
ImagenAuxiliar = padarray(Imagen, [1 1]);
k = 1;
cont = 0;
for Y = 2: (h + 1)
   for X = 2: (w + 1) 
        for i = Y - 1:Y + 1
            for j = X - 1:X + 1
                P1 = ImagenAuxiliar(InicioY, X, 1:3);
                P2 = ImagenAuxiliar(i, j, 1:3);
                Distancia(k, 1) = DistEuclideana(P1, P2);   
                if Distancia(k, 1) <= 8
                    cont = cont + 1;
                end
                k = k + 1;
            end
        end
   end
end

cont
disp(Distancia(1:9, :))