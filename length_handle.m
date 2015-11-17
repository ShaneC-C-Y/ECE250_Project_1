function [ y ] = length_handle(x, t)
% let input row vector x be dividable by t 
% add more NaN on the empty entry -----
% just delete the left entry

len = length(x);
mo = mod(len,t);
y = x(1:len-mo);

end

