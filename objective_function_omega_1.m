function [objective_value, omega_1] = objective_function_omega_1(u, variables, IR_3, tau)
phi_1 = variables(1);
theta_1 = variables(2);
global M;
% Tính toán omega_1 và omega_2
omega_1 = [cos(phi_1)*sin(theta_1), sin(phi_1)*sin(theta_1)];
% Tính toán cH_phi_Hermitian
cH_phi_Hermitian = calculate_c_omega_1(omega_1, theta_1)'; % 1x10
% Tính toán giá trị tích phân và hàm mục tiêu
mul = conj(u) .* (cH_phi_Hermitian*IR_3);
objective_value = abs(trapz(tau, mul))^2;
end