function [ nreal ] = backtoreal( ncomplex )
% decompose complex signal to two real number
% let it go through demapper
% Input:  row vector
% Output: row vector with double size
yreal = real(ncomplex);
yimag = imag(ncomplex);

y = [yreal; yimag];
nreal = y(:)';

end

