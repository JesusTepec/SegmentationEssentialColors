function img = CreaPatronesInv(r, c, x)
    img = zeros(r, c, 3);
    cnt = 1;
    f=1;
    r * c;
    for i=1:r,
        for j=1:c,
            img(i, j, 1) = x(f, cnt);
            img(i, j, 2) = x(f, cnt + 1); 
            img(i, j, 3) = x(f, cnt + 2); 
            f=f+1;
        end
        
    end
    img = uint8(img);
end