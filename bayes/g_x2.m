function rs=g_x2(pwi, sigma, sigma_det, x, u)
%pwi 
%sigma
%sigma_det
%x
%u
mult = 100000;
nr = size(x,2);
x = reshape(x, 1, nr);
sigma_t = reshape(sigma, nr, nr);
inv_sigma = inv(sigma_t * mult);
rs = log(pwi) - 0.5 * log(sigma_det);
r1 = u * inv_sigma * x';
r2 = 0.5 * x * inv_sigma * x';
r3 = 0.5 * u * inv_sigma * u';
r = r1 - r2 - r3;
rs = rs + r;