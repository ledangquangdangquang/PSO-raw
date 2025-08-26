function cH_phi = calculate_c_omega_1(omega_0, theta_1)
% Khởi tạo các biến và thông số
lambda = 1; % Bước sóng
load("pos.mat", "pos_centers")
I = 10;
r_m = pos_centers(:, 11:20)';
for m = 1:I
    c_m(m) = sqrt(sin(theta_1)) * exp(1j * 2 * pi * lambda^(-1) * dot(conj(omega_0)', r_m(m, :)));
end

% Transpose để có hàm c(phi) là ma trận kích thước [I x length(phi)]
cH_phi = c_m;
end