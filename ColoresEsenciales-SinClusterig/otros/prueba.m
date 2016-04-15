
 X = [3 4 5; 2 4 5; 8 9 9; 1 2 3; 7 5 4; 3 4 5; 3 4 6];
 k = 3;

[n,m]=size(X);

% Check if second input is centroids
if ~isscalar(k)
    c=k;
    k=size(c,1);
else
    c=X(ceil(rand(k,1)*n),:);
end

% allocating variables
g0=ones(n,1);
gIdx=zeros(n,1);
D=zeros(n, k);

% Main loop converge if previous partition is the same as current

while any(g0~=gIdx)
%     disp(sum(g0~=gIdx))
    g0=gIdx;
    % Loop for each centroid
    for t=1:k
        d = zeros(n,1);
        % Loop for each dimension
        for s=1:n
            d(s,:) = de2000( X(s,:), c(t,:));
        end
        D(:,t)=d;
    end
    % Partition data to closest centroids
    [z,gIdx]=min(D,[],2);
    % Update centroids using means of partitions
    for t=1:k
        c(t,:)=mean(X(gIdx==t,:));
    end
end