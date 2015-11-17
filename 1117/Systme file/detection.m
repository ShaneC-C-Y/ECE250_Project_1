function pe = detection(rn, L, N)

rn = length_handle(rn, L);

m = reshape(rn,L,[]);
len = length(m);
Nd = len-N;
m = m(:,1:Nd);          % delete several terms which may error

min = len;
for i = 1:L-1
    for j = i+1:L
        r = m(i,:) ~=  m(j,:);
        if sum(r)< min
            min = sum(r);
        end
    end
end
pe = min/len;
end

