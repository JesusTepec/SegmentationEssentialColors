
function patterns = getPatterns(Image)
%%  
% Uso: [Patrones, Alto, Ancho] = CreaPatrones(Imagen)
% 
% Esta funci�n prepara una imagen para se procesada por K-means como
% patrones siendo [R, G, B] un patron para ser analizado
% (Patrones) es una matriz de 3 x n
% n es el n�mero de pixeles.
%
% Autor: Jes�s Antonio Tepec Hern�ndez
%  
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