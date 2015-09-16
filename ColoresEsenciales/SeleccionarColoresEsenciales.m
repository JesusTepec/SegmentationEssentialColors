function SeleccionarColoresEsenciales()
    close all
    Image = imread('../Images/buzo.jpg');
    ImageLAB = applycform(Image, makecform('srgb2lab'));
    
    
    
    
    %show images
    figure, imshow(Image), title('Original Image');
    figure, imshow(ImageLAB), title('Image converted to L*a*b*');
    figure, imshow(ImageLAB(:,:,1))
    figure, imshow(ImageLAB(:,:,2)),
    figure, imshow(ImageLAB(:,:,3)); 