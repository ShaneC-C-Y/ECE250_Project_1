function [xR, xI] = QPSK_constellation_mapper( xp )

% Input:  row vector
% Output: tow row vector

% change a row vector input   [ 1 1 0 0 0 0 1 1]
% to                          [ 1 1
%                               0 0 
%                               0 0
%                               1 1]
if mod(length(xp),2) ~= 0
    xp = xp(1:length(xp)-1);
end

m = reshape(xp,2,[])';


% here didn't handle NaN

d = zeros(size(m));

s = 1/sqrt(2);
for i = 1:size(m,1)
    if isequal(m(i,:),[1,1])
        d(i,1) = s;
        d(i,2) = s;

    elseif isequal(m(i,:),[0,1])
        d(i,1) = -s;
        d(i,2) = s;

    elseif isequal(m(i,:),[1,0])
        d(i,1) = s;
        d(i,2) = -s;

    else
        d(i,1) = -s;
        d(i,2) = -s;
    end
end

xR = d(:,1)';
xI = d(:,2)';

end

