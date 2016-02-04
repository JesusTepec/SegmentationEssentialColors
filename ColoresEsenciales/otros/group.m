function nx = group(x)
    nx(1,:) = x(1,:);
    z = 2;
    for i=2:length(x(:,1))
        insertar = true;
        for j=1:length(nx(:,1))
            if x(i,:) == nx(j,:)
                insertar = false;
                break;
            end
        end
        if insertar == true
            nx(z,:) = x(i,:);
            z = z + 1; 
        end 
    end
end