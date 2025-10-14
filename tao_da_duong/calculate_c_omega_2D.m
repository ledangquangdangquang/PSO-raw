function cH_phi = calculate_c_omega_2D(omega_0)
% --- omega_0 = [cos(phi), sin(phi)] ---
global M pos_centers;
lambda = 1;  % bước sóng chuẩn hoá

% pos_centers: 2×M (x,y)
r_m = pos_centers.';   % (M×2)
c_m = zeros(M,1);

for m = 1:M
    % dot(omega_0, r_m(m,:)) = omega_x*x_m + omega_y*y_m
    phase = 2*pi/lambda * dot(omega_0, r_m(m,:));
    c_m(m) = exp(1j*phase);      % θ=90° => bỏ sqrt(sin θ)
end

cH_phi = c_m;   % vector hướng anten M×1
end
