function s = calculate_s_omega_2(u, omega_2, theta_2, alpha, v)
 c = calculate_cH_omega_2(omega_2, theta_2);
 s = alpha * exp(1j*2*pi*v) * u * c;
end