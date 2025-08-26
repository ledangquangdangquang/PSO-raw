function [objective_value, omega_1] = objective_function_omega_1(u, variables, IR_3, tau)
% Giả định hàm mục tiêu nhận các biến và tính giá trị mục tiêu
% variables là vector chứa [phi_1, theta_1, phi_2, theta_2]

phi_1 = variables(1);
theta_1 = variables(2);

% Tính toán omega_1 và omega_2
omega_1 = [cos(phi_1) * sin(theta_1), sin(phi_1) * sin(theta_1)];


% Tính toán cH_phi_1
cH_phi_1 = calculate_c_omega_1(omega_1, theta_1)';

% Tính toán giá trị tích phân và hàm mục tiêu
result = zeros(10, 1);
integral_value = zeros(10, 1);
for i = 1:10
    c = cH_phi_1(i, :);
    mul = u(:, 1) * c .* IR_3(:, i);
    integral_value(i) = trapz(tau, mul);
    % Sum the squared absolute values of integral value
    a = real(integral_value(i));
    b = imag(integral_value(i));
    result(i) = a*a + b*b;
end

% Tổng các kết quả cuối cùng
sum_columns = sum(result);
objective_value = round(sum_columns, 8);
end