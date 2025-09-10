function [objective_value, omega_2] = objective_function_omega_2(u, variables,  IR_3, tau)
% Giả định hàm mục tiêu nhận các biến và tính giá trị mục tiêu
phi_2 = variables(1);
theta_2 = variables(2);

% Tính toán omega_1 và omega_2
omega_2 = [cos(phi_2) * sin(theta_2), sin(phi_2) * sin(theta_2)];
% Tính toán cH_phi_1 và cH_phi_2
cH_phi_2 = calculate_cH_omega_2(omega_2, theta_2);

% Tính toán giá trị tích phân và hàm mục tiêu
mul = conj(u).*(cH_phi_2*IR_3);
objective_value = trapz(tau, mul)^2;
% result = zeros(10, 1);
% integral_value = zeros(10, 1);
% for i = 1:2
%     mul = u(:, 1) * cH_phi_2 .* IR_3(:, i);
%     integral_value(i) = trapz(tau, mul);
%     % Sum the squared absolute values of integral value
%     a = real(integral_value(i));
%     b = imag(integral_value(i));
%     result(i) = a*a + b*b;
% end
% 
% % Tổng các kết quả cuối cùng
% sum_columns = sum(result);
% 
% % Trả về giá trị của hàm
% objective_value = round(sum_columns, 8);
end