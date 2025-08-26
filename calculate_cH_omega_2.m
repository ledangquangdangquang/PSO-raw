function cH_phi = calculate_cH_omega_2(omega_2, theta_2)
% Khởi tạo các biến và thông số
lambda = 1; % Bước sóng
load("VA.mat", "used_VAs")
r_m = used_VAs{1,1}(:, 1)';
c_m = sqrt(sin(theta_2)) * exp(1j * 2 * pi * lambda^(-1) * dot(conj(omega_2), r_m));
% Transpose để có hàm c(phi) là ma trận kích thước [I x length(phi)]
cH_phi = c_m';
end