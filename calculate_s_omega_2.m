function s = calculate_s_omega_2(u, omega_2, theta_2, alpha, v)
 c = calculate_cH_omega_2(omega_2, theta_2); % 1x1
 s = c * alpha * exp(1j*2*pi*v) * u; % 1x15000
end