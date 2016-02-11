function img = CreaPatronesInv(r, c, x)
    x = double(x);
    img = [];
    for i = 1:c:r,
        ima = x(i:i + col - 1, :);
        img = [img ; permute(ima, [3 1 2])];
    end
    img=uint8(img);
end