function objective_value = objective_function_tau(tau, tau_0, IR_3)
global M md;
u = generatePulse(md, tau_0, tau, 0);% 1x15000
result = zeros(M, 1);
for m = 1:M
    % Tich cua hai tin hieu
    mul = conj(u) .* IR_3(m, :);
    % Tich phan tren mien thoi gian D_i
    integral = trapz(tau, mul);
    % Tinh toan ket qua cuoi cung
    result(m) = abs(integral)^2;
end
% Tong cac ket qua cuoi cung
objective_value = sum(result);
end
