function umbral = obtenerUmbral(centroides, k, divisor, minimo, maximo)
    kurt = kurtosis(centroides(:))
    varianza = var(centroides(:))
    promedio = median(centroides(:))
    desviacion = std(centroides(:))
%     threshold = (varianza / k)
%     fprintf('kurtosis: %f , varianza: %f , promedio: %f , desStd: %f',kurt, varianza, promedio, desviacion)
%     if(threshold > maximo)
%        t1 = (promedio) / (desviacion + kurt)
%        umbral = (threshold + kurt) / t1
%        disp('mayor')
%     elseif(threshold < minimo)
%         umbral = (threshold + kurt) / divisor
%         disp('menor')
%     else
%         umbral = (threshold + kurt) / 20  
%     end
%     
    diferencia = abs(promedio - desviacion) / divisor
    p = maximo / 4;
    if(diferencia > maximo)
        umbral = diferencia / (kurt)
        disp(1)
    elseif(diferencia > (p * 3))
        umbral = diferencia / (kurt / 2)
        disp(2)
    elseif(diferencia > p && diferencia < (p * 2))
       umbral = diferencia / 0.8
       disp(3)
    elseif(diferencia < p)
       umbral = diferencia / (desviacion / 20)%/200
       disp(4)
    else
        umbral = diferencia / 1.2
        disp(5)
    end
%     if(diferencia < 0.12)
%         if(diferencia < 0.05)
%             umbral = diferencia / (varianza / 2)
%             disp('1')
%         elseif diferencia < 0.085
%             umbral = diferencia / (varianza * 3)
%             disp('2')
%         else
%            umbral = diferencia / varianza
%             disp('2.5') 
%         end
%     elseif(diferencia > 0.409)
%         umbral = (promedio - desviacion) / 6.5
%         disp('3')
%     elseif(diferencia > 0.3)
%         umbral = (promedio - desviacion) / 1.3
%         disp('4')
%     else  
%         umbral = (promedio - desviacion)
%         disp('5')
%     end
%     if umbral < 0
%         umbral = umbral * -1
%     end
    
end