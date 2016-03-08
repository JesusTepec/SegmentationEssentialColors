function x=posk(row,col,varargin)

% Posprocesamiento de una imagen tras aplicar k-means.
% Acomodaremos la matriz de centroides 'c' de manera que reconstruyamos
% la imagen "x" con sus dimensiones originales.

c=ParseInputs(varargin{:});
c=double(c);
d=size(c,2);

if mod(col,d)~=0,
    error('MATLAB: El número de columnas (%i) de x debe ser divisible entre d (%i)',col,d);
end
x=zeros(row,col);
z=1;
for i=1:row,
    for k=1:d:col-1,
        for j=1:d,
            x(i,j+k-1)=c(z,j);
        end
        z=z+1;
    end
end
x=uint8(x);

function c=ParseInputs(varargin)
c=varargin{1};