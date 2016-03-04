function cov = mcovar(colores)
    mu = mean(colores);
    [n,~] = size(colores);
    colores = colores - repmat(mu,[n,1]);
    cov = (colores'*colores)/n;
end