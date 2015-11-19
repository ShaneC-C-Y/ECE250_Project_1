function dn = repetition_encoder(bn, n)
% z = [ -----bn-----
%       -----bn-----
%             .
%             .
%       -----bn------]
% z have n rows

z = repmat(bn,n,1);
dn = z(:)';

end

