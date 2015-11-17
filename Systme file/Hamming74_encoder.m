function [ dn ] = Hamming74_encoder( bn )

% Input:  row vector
% Output: row vector, size become 7/4

k = 4;
bn1 = length_handle(bn, k);

z = reshape(bn1, k, [])';  % every 4 bits in a row vector

% M = [ 1 0 0 0 1 1 0;
%       0 1 0 0 1 0 1;
%       0 0 1 0 0 1 1;
%       0 0 0 1 1 1 1];
  

% matrix for (7,4) coding
M2 = [1 1 0;
      1 0 1;
      0 1 1;
      1 1 1];
  
dn3 = z*M2;
dn3 = mod(dn3,2);
dn2 = [z dn3];
    
t = dn2';
dn = t(:)';

end

