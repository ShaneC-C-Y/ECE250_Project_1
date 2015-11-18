function [ bnhat ] = repetition_decoder( dnhat, L )
% majority

dnhat2 = reshape(dnhat, L, []);
m = sum(dnhat2,1);

% check value floor(L/2)
% L should be odd value that can detect well;
c = L/2;
bnhat = m>c;

end

