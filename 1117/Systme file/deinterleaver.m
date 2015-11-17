function rn = deinterleaver( yp, time_diversity, Ns )

% Input: row vector  [ 1 0 0 1 1 | 1 0 0 1 1]
% output should be like [ 1 1 0 0 0 0 1 1 1 1 ]
L = time_diversity;
N = Ns;

temp = length_handle(yp,L*N);

r = reshape(temp,L*N,[])';

rn = zeros(size(r));

for i = 1:L
    for j = 1:N
        rn(:,i+ (j-1)*L) = r(:,(i-1)*N+j);
    end
end

rn = torowvector(rn);

end

