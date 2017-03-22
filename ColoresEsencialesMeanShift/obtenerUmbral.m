function umbral = obtenerUmbral(centroides, k, divisor, maximo, minimo)
    kurt = kurtosis(centroides(:));
    threshold = (var(centroides(:)) / k)
    if(threshold > maximo)
       t1 = ((median(centroides(:)) / std(centroides(:)))+ kurt)
       umbral = (threshold + kurt) / t1
    elseif(threshold < minimo)
        umbral = (threshold + kurt) / divisor
    else
        umbral = (threshold + kurt)   
    end
end