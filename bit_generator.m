function bn = bit_generator( Num )
%%%%%%%%%%%%%%%%%%%%%
% generate bit 0, 1 %
%%%%%%%%%%%%%%%%%%%%%

bn = sign(randn(1,Num))./2 + 0.5;
end

