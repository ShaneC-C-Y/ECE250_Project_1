function [ yp ] = mergesignal(ypR, ypI)
%merge two divide signal
yp = [ypR; ypI];
yp = yp(:)';

end

