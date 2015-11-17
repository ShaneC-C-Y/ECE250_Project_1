function dn = repetition_encoder(bn, L)

z = bn;
for i = 1:L-1
    z = [z; bn];
end
dn = z(:)';

end

