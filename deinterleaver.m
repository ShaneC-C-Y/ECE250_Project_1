function yp = deinterleaver( y_afterfilter, L, N )

% Input(yp):    row vector, length N*L
% Output:       row vector, size the same
assert(length(y_afterfilter) == N*L);

yp = zeros(size(y_afterfilter));

for i = 1:L
    for j = 1:N
        yp(i+ (j-1)*L) = y_afterfilter((i-1)*N+j);
    end
end

yp = torowvector(yp);

end

