function umbral = obtenerUmbral(centroides, k, divisor, minimo, maximo)
    kurt = kurtosis(centroides(:));
    varianza = var(centroides(:));
    promedio = median(centroides(:));
    desviacion = std(centroides(:));
    threshold = (varianza / k)
    fprintf('kurtosis: %f , varianza: %f , promedio: %f , desStd: %f',kurt, varianza, promedio, desviacion)
    if(threshold > maximo)
       t1 = (promedio) / (desviacion + kurt)
       umbral = (threshold + kurt) / t1
       disp('mayor')
    elseif(threshold < minimo)
        umbral = (threshold + kurt) / divisor
        disp('menor')
    else
        umbral = (threshold + kurt) / 20  
    end
    
end