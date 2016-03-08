
function patterns = getPatterns(Image)
%%  
% Usage: patterns = getPatterns(Imagen)
% 
% Esta función prepara una imagen para ser procesada por K-means como
% patrones siendo [R, G, B] un patron para ser analizado
% (Patrones) es una matriz de 3 x n
% n es el número de pixeles.
%
% Autor: Jesús Antonio Tepec Hernández
% 
    if(size(Image, 3) == 1)
        [h,w] = size(Image);
        patterns = [Image(:)];
        k = 1;
        for i = 1:h,
            for j=1:w,
                paterns(k,1)=Image(i,j);
                k = k+1;
            end
        end
    else
        r = Image(:, :, 1);
        g = Image(:, :, 2);
        b = Image(:, :, 3);

        r = r';
        g = g';
        b = b';

        r = [r(:)];
        g = [g(:)];
        b = [b(:)];

        patterns = [r, g, b];
    end
end