function [ dn ] = Hamming74_encoder(bn)

% Input:  row vector, 1 by Num
% Output: row vector, 1 by (7/4)Num

k = 4;

% every 4 bits in a column vector
% p = [ bn[1] ...   ...
%         .    .     .
%       bn[4] ... bn[4*N~] ]
bn1 = length_handle(bn, k);
p = reshape(bn1, k, []);

% very inportant to check the version of coding matrix
%https://en.wikipedia.org/wiki/Hamming(7,4)#Decoding
G = [ 1 1 0 1;
      1 0 1 1;
      1 0 0 0;
      0 1 1 1;
      0 1 0 0;
      0 0 1 0;
      0 0 0 1];

% x here is a 7 by N~ matrix
% reshape to a row vector
x = mod(G*p,2);
dn = x(:)';

end

