function img = cerradura(img, t)
    elemt = strel('diamond',t);
    img(:,:,1) = imclose(img(:,:,1), elemt);
    img(:,:,2) = imclose(img(:,:,2), elemt);
    img(:,:,3) = imclose(img(:,:,3), elemt);
end