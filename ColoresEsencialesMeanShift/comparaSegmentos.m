function ir = comparaSegmentos(imgSeg, iter, nombres, ruta)
    im1 = imgSeg(:, :, 1);
    ir = zeros(6,1);
    for i=1:5
        if exist([ruta,'\humanSeg\' ,nombres{iter},num2str(i), '.seg'])
            im2 = readSeg([ruta,'\humanSeg\',nombres{iter},num2str(i), '.seg']);
            [index, ~, ~] = compare_segmentations(im1, im2);
            ir(i)= index;
        end 
    end
end 