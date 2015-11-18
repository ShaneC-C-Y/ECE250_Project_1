function [bnhat] = Hamming74_decoder( rn )

n = 7;

len = length(rn);
mo = mod(len,n);
if mo ~=0
    rn = rn(1:len-mo);
end
% need colume vector to multiply the matrix H
% rn3 is a row number n (length n codeword) matrix
rn3 = reshape(rn,n,[]);

% z is a 3 row matrix with Num+ columns
z = check(rn3);

% %% get the error before correction
% pe = cal_error(z);

%% error correction
% suppose 1 bit error
e_pos = z(1,:) + 2.*z(2,:) + 4.*z(3,:);  % find which bit error)

rn3_correct = rn3;
for i = 1:length(e_pos)    % how many should go through
    if e_pos(i) > 0
        rn3_correct(e_pos(i),i) = 1 - rn3(e_pos(i),i);
    end
end

% %% check codeword after correction
% % calculate corrected codeword error, 
% % it should be 0 no matter how many bits error
% z_correct = check(rn3_correct);
% pe2 = cal_error(z_correct);

%% output
% output the result of decoder
bnhat2 = rn3_correct(1:4,:);
bnhat = bnhat2(:)';

end

%% helper function
function z = check(r)
% parity check matrix
% very inportant to check the version of coding matrix
% https://en.wikipedia.org/wiki/Hamming_code
H = [ 1 1 0 1 1 0 0;
      1 0 1 1 0 1 0;
      0 1 1 1 0 0 1];
  
z1 = H*r;        
z = mod(z1,2);
end

function pe_f = cal_error(z_f)
% calculate the prob. error in codeword
s = sum(z_f);

e = length(find(s~=0));

pe_f = e/length(s);
end