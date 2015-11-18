function [ yp ] = v2_backtoreal( yp_temp )
% decompose complex signal to real signal
% Input(yp_temp):            row vector, 1 by (7/4)Num
% Output(yp):   row vector, double size
yp_tempR = real(yp_temp);
yp_tempI = imag(yp_temp);

yp_temp = [yp_tempR; yp_tempI];
yp = yp_temp(:)';
end

