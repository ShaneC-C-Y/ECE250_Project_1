function xp = interleaver( dn, time_diversity, Ns)

% Input: row vector
% Output row vector, size the same
N = Ns;
L = time_diversity;

% make every L*N bits in a row
xp1 = length_handle(dn, N*L);

y = reshape(xp1,L*N,[])';

xp = zeros(size(y));               % output is the same size

for i = 1:L
    for j = 1:N
        xp(:,(i-1)*N+j) = y(:,i+ (j-1)*L);
    end
end

xp = torowvector(xp);

end

