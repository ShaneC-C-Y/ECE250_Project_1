function [ bnhat ] = repetition_decoder( dnhat, n )

% majority logic decoding
% dhnat2 = [ dn~[1] ...   ...
%            dn~[2] ...   ...
%              .     .     .
%            dn~[L] ... dn~[L*Num] ]  
%
% m =      [ bn~[1] ...  bn~[Num]  ]
dnhat2 = reshape(dnhat, n, []);
m = sum(dnhat2,1);

% check value L/2
% it works only when L = 2t + 1
% otherwise there will be detection error
c = n/2;
bnhat = m>c;

end

