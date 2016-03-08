function img = getPixeles(r, c, x)
    if(size(x, 2) == 1)
        img = zeros(r, c);
        f=1;
        for i=1:r,
            for j=1:c,
                img(j, i) = x(f);
                f=f+1;
            end
        end
        img = uint8(img);
        imshow(img)
        disp('hola')
    else
        x = double(x);
        dimc=size(x,1);
        img = [];
        for i = 1:c:dimc,
            ima = x(i:i + c - 1, :);
            img = [img ; permute(ima, [3 1 2])];
        end
        img=uint8(img);
          imshow(img)
    end
end