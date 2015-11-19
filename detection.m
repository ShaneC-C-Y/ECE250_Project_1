function pe = detection(dnhat, L, bn)
% detection here should consider about bit error
% the number of total bit is Num*L
% so we need to know bn here
% Input(dnhat):     row vector, 1 by Num*L
% Input(bn):        row vector, 1 by Num

% make dnhat to be L by Num matrix
% dnhat = [dn~[1] ...    ...
%          dn~[2] ...    ...
%            .     .      .
%          dn~[L] ... dn~[L*Num] ]
% bn =    [bn[1]  ...   bn[Num]  ]
dnhat = length_handle(dnhat, L);
dnhat = reshape(dnhat,L,[]);

% check the length, make it comparable
Num = min(length(dnhat), length(bn));
dnhat = dnhat(:,1:Num);
bn = bn(1:Num);

% bn_matrix = [ -----bn-----
%               -----bn-----
%                     .
%               -----bn-----]
bn_matrix = repmat(bn,L,1);

err = bn_matrix ~= dnhat;
error_count = sum(sum(err));

pe = error_count/L/Num;
end

