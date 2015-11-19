function xp = interleaver( dn, L, N)

% Input(dn):    row vector, length N*L
% Output:       row vector, size the same
assert(length(dn) == N*L);

xp = zeros(size(dn));

for i = 1:L
    for j = 1:N
        xp((i-1)*N+j) = dn(i+ (j-1)*L);
    end
end

xp = torowvector(xp);

end

