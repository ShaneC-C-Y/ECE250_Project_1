function [ y_est ] = channel_estimator_new(y, h, N)
% y = [a1 b1 ...   h_invmatrix = [h1  0  0 ...
%      a2 b2 ...                   0 h2  0 ...
%      a3 b3 ...]                  0  0 h3 ...]
h_invmatrix = diag(1./h);
y = reshape(y, N, []);
y_est = real(y*h_invmatrix);

% here is real
y_est = y_est(:)';

%%%%%%%%%%
%some change
%%%%%%%%%

%%%
%test for stash
%%%

end

