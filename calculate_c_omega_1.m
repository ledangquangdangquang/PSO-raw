function cH_phi = calculate_c_omega_1(omega_0, theta_1)
lambda = 1; % Bước sóng
global M pos_centers;
r_m = pos_centers(:, 11:20)';
c_m = zeros(M, 1);
for m = 1:M
    c_m(m) = sqrt(sin(theta_1)) * exp(1j*2*pi*lambda^(-1) * dot(omega_0, r_m(m, :)));
end
cH_phi = c_m; % 10x1
end