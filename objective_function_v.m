function objective_value = objective_function_v(u, v0, IR_3, omega_1, omega_2, tau)
result = zeros(10, 1);
integral_value = zeros(10, 1);
for i = 1:10
    c = dot(omega_1, omega_2);
    mul = u(:, 1) * exp(-1j * 2 * pi * v0) * c .* IR_3(:, i);
    integral_value(i) = trapz(tau, mul);
    % Sum the squared absolute values of integral value
    a = real(integral_value(i));
    b = imag(integral_value(i));
    result(i) = a*a + b*b;
end

% Tổng các kết quả cuối cùng
sum_columns = sum(result);

% Trả về giá trị của hàm
objective_value = round(sum_columns, 8);
end