%Program: k-means
%Created on: 02/12/12, 01:03 a.m.
%Author: Luigi Pérez Calzada
clc;
clear all;
obj=['A' 'B' 'C' 'D'];
tam=size(obj);%tamaño de los objetos
atri=[1 1;
      2 1;
      4 3;
      5 4];
atri %imprimimos atri
k=input('Da el valor de k: '); %de preferencia que K sea igual a 2
while (k<1 || k>tam(1,2))
   k=input('Da el valor de k: '); 
end
%se elije el número de objetos 'k' como centroides
for i=1:k
   C(i,:)=[atri(i,1) atri(i,2)];
end
%Calculamos distancia euclidiana
iter=1;
D=zeros(k,tam(1,2));%creamos nuestra matriz de 2*4
Comp=zeros(k,tam(1,2));
while(1==1)
for i=1:tam(1,2)
    for j=1:k
        exp1=(atri(i,1)-C(j,1))^2+(atri(i,2)-C(j,2))^2;
        temp=sqrt(exp1);
        D(j,i)=temp;
    end
end
D %operaciones
%asignamos grupo al que pertenecen
G=zeros(k,tam(1,2));
for i=1:tam(1,2)
    pos=1;
    tm=D(1,i);
    for j=1:k
       if(D(j,i)<=tm)%buscamos el mayor
           tm=D(j,i);
           pos=j;
       end
    end %end for j
    G(pos,i)=1;
end %end for i
G %grupos
%reajustar centroides
for i=1:k
   sum1=0; sum2=0;count=0;
   for j=1:tam(1,2)
      if(G(i,j)==1) %si halla un 1
          count=count+1;
          if(i==1)
              sum1=sum1+atri(j,i); %sumamos valores
              sum2=sum2+atri(j,i+1);
          else
              sum1=sum1+atri(j,i-1);
              sum2=sum2+atri(j,i);
          end
      end%end if G
   end%end for j
   if(count>1)%si en el grupo tenemos más de un registro
      tC1=sum1/count;
      tC2=sum2/count;
      C(i,:)=[tC1 tC2];%reajustamos centroide
   else
       C(i,:)=[atri(i,1) atri(i,2)];%si no pasamos valores del centroide original
   end
end
C%valores de los centroides
%repetir proceso hasta igualdad
if(G==Comp) 
    for i=1:k
        for j=1:tam(1,2)
            if(G(i,j)==1)
                fprintf('El obj %c pertenece al grupo %d \n',obj(j),i);
            end
        end
    end
    break; end
Comp=G;%a nuestra matriz temporal le asignamos nuestro datos de los grupos
iter=iter+1;%incrementamos número de iteraciones
end %end while true
fprintf('Fueron %d iteraciones para que ya no se reajustará el centroide\n',iter);
