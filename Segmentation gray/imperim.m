function [perimeters,cent,c]=imperim(im,centroids,colors)

[row,col,~]=size(im);
c=zeros(row,col,colors);
perimeters=zeros(row,col,colors);
cent=permute(centroids,[1 3 2]);
for k=1:colors,
    for i=1:row,
        for j=1:col
            c(i,j,k)=isequal(im(i,j,:),cent(k,:,:));
        end
    end
    c(:,:,k)=bwareaopen(c(:,:,k),1000);
    perimeters(:,:,k)=bwperim(c(:,:,k));
    
end
