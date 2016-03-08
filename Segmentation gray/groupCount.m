function [total, ux] = groupCount(x)

    [ux, ia, ic] = unique(x, 'rows');
    [h,~] = size(ux);
    ht = hist(ic, h);
    ux(:,4) = ht';
    [total,~] = size(ux);
end


        
        