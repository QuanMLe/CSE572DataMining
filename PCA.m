function [V] = PCA(Data)

% input should be n*m (m is #of features)

for i = 1 : size(Data, 2)
    Data(:, i) = Data(:, i) - mean(Data(:, i));
end
C = cov(Data);
[V, D] = eig(C);

v1 = V(13, :);
v2 = V(12, :);

U = [v1 ;v2];

newData = Data * U';
end

