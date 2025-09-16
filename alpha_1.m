function objective_value = alpha_1(u, IR_3, omega_1, omega_2, theta_1, theta_2, v0, tau)
    global md;
    Ta = md.Tp;
    Pu = calculate_power(u);
    c_omega_1 = calculate_c_omega_1(omega_1, theta_1);
    c_norm_2 = norm(c_omega_1)^2;  
    I = 6; 
    IPS = 1/(I * c_norm_2 * Ta * Pu);
    %% calculate z
    mul = conj(u) .* exp(-1j*2*pi*v0*tau) .* (c_omega_1' * IR_3);
    z = abs(trapz(tau, mul));
    %% return
    objective_value = IPS * z;
end