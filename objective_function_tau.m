function objective_value = objective_function_tau(tau, tau_0, IR_3)
md.type = 'RRC';
md.Tp = 0.5e-9;
md.beta = 0.6;
M = 10;
I = 1;
tau = (0:4.6414e-12:14999*4.6414e-12)';
u = generatePulse(md, tau_0, tau, 0);
for m = 1:M
    for i = 1:I
        % Tich cua hai tin hieu
        mul = u(:, i) .* IR_3(:, m);
        % Tich phan tren mien thoi gian D_i
        result(m, i) = trapz(tau, mul);
        % Tinh toan ket qua cuoi cung
        ketqua(m, i) = abs(result(m, i))^2;
    end
end
% Tong cac ket qua cuoi cung
sum_columns = sum(ketqua,1);
%Tra ve gia tri cua ham
objective_value = sum_columns;
end
