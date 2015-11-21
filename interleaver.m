function xp = interleaver( dn, L, N)

% here we have two set of N*L
% Input(dn):    row vector, length N*L
% Output:       row vector, size the same

assert(length(dn) == 2*N*L);

dn_matrix = reshape(dn, N*L, 2);
xp2 = zeros(size(dn_matrix));

for i = 1:L
    for j = 1:N
        xp2((i-1)*N+j, :) = dn_matrix(i+ (j-1)*L, :);
    end
end

xp = xp2(:)';

end

