function ci=centinit(k,varargin)

% 
% Modo de uso: ci=centinit(k,x)
% 
% Esta función inicializa los centroides de la base de datos "x"
% basándose en partir "x" en "k+1" partes iguales y tomar un valor
% pseudo-aleatorio en cada rango en que se dividió "x". Esto con el fin de
% no tomar valores compleatamente pseudo-aleatorios, sino que estos valores
% tengan cierto espacio de distribución a través de toda la "x".
% k es el número de centroides.
% x es la base de datos.
% espacio obtiene el rango de valores para cada feature del centroide.

x = ParseInputs(varargin{:});

x=double(x);
dimx=size(x,2);
mini=min(x);
maxi=max(x);
espacio=zeros(dimx,k+1);
ci=zeros(k,dimx);

for i=1:size(maxi,2),
    espacio(i,:)=linspace(mini(i),maxi(i),k+1);
end

for i=1:dimx,
    for j=1:k,
        ci(j,i)=espacio(i,j)+(espacio(i,j+1)-espacio(i,j)).*rand(1,1);
    end
end

% d=dist(ci,x,'manhattan')
% p=size(d,1);
% minima=min(d,[],2)

% for i=1:p,
%     for j=1:k,
%         if minima(i)==d(i,j),


function I = ParseInputs(varargin)
% iptchecknargin(1,1,nargin,mfilename); %Número de entradas de 1 a 1
I = varargin{1};