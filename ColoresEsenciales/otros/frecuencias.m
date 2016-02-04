function h = frecuencias(data, image)
    n = length(data(:,1));
    ni = length(image(:,1));
    cont = zeros(n,1);
    for i = 1:n
        for j = 1:ni
            if data(i,:) == image(j,:)
                cont(i)= cont(i) + 1;
            end
        end
    end
    h = (cont > 5);
    h = sum(h);
end