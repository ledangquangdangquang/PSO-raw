function s = genPath(tau_delay, phi, alpha, v)


% ================== THÔNG SỐ XUNG ==================
md.type = 'RRC';
md.Tp   = 0.5e-9;      % độ rộng xung (0.5 ns)
md.beta = 0.6;         % hệ số roll-off

N  = 15000;            % tổng số mẫu quan sát
Ts = 4.6414e-12;       % chu kỳ lấy mẫu (s)
tau = (0:N-1)*Ts;      % trục thời gian cố định


% ================== XÂY DỰNG p(t) ==================
p_t = generatePulse(md, tau_delay, tau, 0);  % xung RRC cơ sở


% ================== CẤU HÌNH MẢNG ANTEN 2D ==================
global M pos_centers;
M = 10;                           % 10 anten thu
d = 0.025;                        % khoảng cách 0.025 m = 2.5 cm
pos_centers = [0:d:(d*(M-1));     % toạ độ x
               zeros(1,M)];       % toạ độ y (phẳng 2D)

% ====== VECTOR HƯỚNG SÓNG OMEGA_0 (2D) ======
omega_0 = [cos(phi), sin(phi)];   % vì 2D, bỏ trục z

% ====== TÍNH VECTOR HƯỚNG c(phi) ======
c = calculate_c_omega_2D(omega_0);  % dùng hàm 2D mới

% ====== TÍNH s(t) – CÓ DOPPLER THEO THỜI GIAN ======
s = c * (alpha .* exp(1j*2*pi*v*tau)) .* p_t;   % (M×N)
end