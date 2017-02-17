function umbral = obtenerUmbral(centroides, k, divisor, maximo)
    kurt = kurtosis(centroides(:));
    threshold = (var(centroides(:)) / k); 
    t1 = divisor;
    if(threshold > maximo)
       t1 = ((median(centroides(:)) / std(centroides(:)))+ kurt);
    end
    umbral = (threshold + kurt) / t1;
end