function [fg1, fg2] = showcharts(originalImage, y)
    fg1 = 0;
    x = double (originalImage);
    sample = zeros(size(x,1),size(x,2));
    sample(1:3:end,1:3:end) = 1;

    R = x(:,:,1); Rx = R(sample==1); Rn = randn( numel(Rx),1 )/3;
    G = x(:,:,2); Gx = G(sample==1); Gn = randn( numel(Rx),1 )/3;
    B = x(:,:,3); Bx = B(sample==1); Bn = randn( numel(Rx),1 )/3;  

%     fg1 = figure(), 
%     scatter3( round(Rx(:)-Rn), round(Gx(:)-Gn),round( Bx(:)-Bn), 3, [ Rx(:), Gx(:), Bx(:) ]/255 );
%     title('Distribucion de pixeles antes de Agrupar Colores')
%     xlim([0,255]),ylim([0,255]),zlim([0,255]);axis square
    R = y(:,:,1); Ry = R(sample==1); Rn = randn( numel(Rx),1 )/3;   
    G = y(:,:,2); Gy = G(sample==1); Gn = randn( numel(Rx),1 )/3;
    B = y(:,:,3); By = B(sample==1); Bn = randn( numel(Rx),1 )/3;
    fg2 = figure(), 
    scatter3( round(Ry(:)-Rn), round(Gy(:)-Gn), round(By(:)-Bn), 3, [ Rx(:), Gx(:), By(:) ]/255 );
    title('Distribucion de pixeles después de Agrupar Colores')
    xlim([0,255]),ylim([0,255]),zlim([0,255]);axis square
end