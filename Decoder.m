function [ bnhat, retransmit_case ] = Decoder(dnhat, n, type )
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% need type                                                     %
% and it will tell the System which bit need to do retransmit   %
% in Hamming74, there is no retransmit                          %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
switch type
    case 'hamming74'
        bnhat = Hamming74_decoder(dnhat);
        retransmit_case = [];
    case 'repetition'
        [bnhat, retransmit_case] = repetition_decoder(dnhat, n);
    otherwise
        warning('Unexpected type')
end
end

