function rs=g_x(pwi, sigma, sigma_det, x, u)
%pwi 
%sigma
%sigma_det
%x
%u
nr = size(x,3);
x = reshape(x, 1, nr);
sigma = reshape(sigma, nr, nr);
inv_sigma = inv(sigma);
rs = log(pwi) - 0.5 * log(sigma_det);
r1 = u * inv_sigma * x';
r2 = 0.5 * x * inv_sigma * x';
r3 = 0.5 * u * inv_sigma * u';
r = r1 - r2 - r3;
rs = rs + r;