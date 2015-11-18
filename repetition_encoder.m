function dn = repetition_encoder(bn, L)
% z = [ -----bn-----
%       -----bn-----
%             .
%             .
%       -----bn------]
% z have L rows

z = repmat(bn,L,1);
dn = z(:)';

end

