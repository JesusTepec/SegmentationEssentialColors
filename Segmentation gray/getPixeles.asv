function img = getPixeles(r, c, x)
    x = double(x);
    dimc=size(x,1);
    img = [];
    for i = 1:c:dimc,
        ima = x(i:i + c - 1, :);
        img = [img ; permute(ima, [3 1 2])];
    end
    img=uint8(img);
end