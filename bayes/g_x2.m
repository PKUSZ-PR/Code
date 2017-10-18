function rs=g_x2(pwi, sigma, sigma_det, x, u)
%dircimenant function of class of which samples match gaussian distribution
%pwi  the  prior probability of class i
%sigma the convariance matrix of class i
%sigma_det the det of convariance matrix
%x the sample with n dims
%u the mean of training samples
%rs the return value of the function
nr = size(x,2);
x = reshape(x, 1, nr);
sigma_t = reshape(sigma, nr, nr);
inv_sigma = inv(sigma_t);
rs = log(pwi) - 0.5 * log(sigma_det);
r1 = u * inv_sigma * x';
r2 = 0.5 * x * inv_sigma * x';
r3 = 0.5 * u * inv_sigma * u';
r = r1 - r2 - r3;
rs = rs + r;