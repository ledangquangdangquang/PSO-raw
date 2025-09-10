function objective_value = alpha_1(u, IR_3, omega_1, omega_2, theta_1, theta_2, v0, tau)
global M md;
Ta = md.Tp;
% Ta = md.Tp * 15000;
Pu = calculate_power(u);

c_omega_1 = calculate_c_omega_1(omega_1, theta_1);
c_norm_2 = norm(c_omega_1)^2;  % ||c||^2 cho một sóng
I = 1;  % số khoảng quan sát
IPS = 1/(I * c_norm_2 * Ta * Pu);
%% calculate z
mul = conj(u) .* exp(-1j*2*pi*v0*tau) .* (c_omega_1' * IR_3);
z = abs(trapz(tau, mul));
%% return7890
objective_value = IPS * z;
end