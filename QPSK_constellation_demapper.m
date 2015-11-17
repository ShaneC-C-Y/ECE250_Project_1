function yp = QPSK_constellation_demapper( y )

% Input:  row vector, real 
% Output: row vector, same size
% here didn't handle NaN

% because only positive or negetive
yp = y>0;

end

