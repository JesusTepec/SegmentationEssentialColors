%  
% Uso: [Patrones, Alto, Ancho] = CreaPatrones(Imagen)
% 
% Esta función prepara una imagen para se procesada por K-means como
% patrones siendo [R, G, B] un patron para se analizado
% (Patrones) es una matriz de 3 x n
% n es el número de pixeles.
% Autor: Jesús Antonio Tepec Hernández

function [paterns,h,w] = CreaPatrones(img)   
    imgR = img(:,:,1);
    imgG = img(:,:,2);
    imgB = img(:,:,3);
    
    [h,w] = size(imgR);
    tam = h*w;
    paterns = zeros(tam,3);
    k = 1;
    for i = 1:h,
        for j=1:w,
            paterns(k,1)=imgR(i,j);
            paterns(k,2)=imgG(i,j);
            paterns(k,3)=imgB(i,j);
            k = k+1;
        end
    end
   % paterns = uint8(paterns);
end