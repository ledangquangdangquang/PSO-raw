function objective_value = objective_function_v(u, v0, IR_3, omega_1, theta_1, tau)
% calculate z
c_omega_1 = calculate_c_omega_1(omega_1, theta_1);
mul = conj(u) .* exp(-1j*2*pi*v0*tau) .* (c_omega_1' * IR_3);
z = trapz(tau, mul);
% Trả về giá trị của hàm
objective_value = abs(z);
end