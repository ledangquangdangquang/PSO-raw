function cH_phi = calculate_cH_omega_2(omega_2, theta_2)
% Khởi tạo các biến và thông số
lambda = 1; % Bước sóng
load("VA.mat", "used_VAs")
r_m = [-used_VAs{1,1}(1,1) used_VAs{1,1}(2,1)];
cH_phi = sqrt(sin(theta_2)) * exp(1j*2*pi*lambda^(-1) * dot(omega_2, r_m)); % 1x1
end