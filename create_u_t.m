clc; clear; close all;

% ================= THÔNG SỐ XUNG =================
md.type = 'RRC';
md.Tp   = 0.5e-9;      % duration 0.5 ns
md.beta = 0.6;         % roll-off factor

N  = 15000;            % số mẫu tổng
Ts = 4.6414e-12;       % chu kỳ lấy mẫu
tau = (0:N-1)*Ts;      % trục thời gian

% ================= CẤU TRÚC BURST =================
K = 5;                 % số symbol trong 1 burst
Tp = 2e-9;             % khoảng giữa 2 symbol
a_k = [1 -1 1 1 -1];   % chuỗi hệ số PN hoặc BPSK

% ================= XÂY DỰNG a(t) =================
a_t = zeros(size(tau));    % vector chứa 1 burst
for k = 0:K-1
    tau_delay = k * Tp;    % độ trễ từng symbol
    p_t = generatePulse(md, tau_delay, tau, 0); % p(t - kTp)
    a_t = a_t + a_k(k+1) * p_t;                 % cộng chồng
end

% ================= XÂY DỰNG u(t) (lặp lại burst) =================
num_repeat = 3;             % số lần lặp lại burst
u_t = repmat(a_t, 1, num_repeat);
t_u = (0:length(u_t)-1)*Ts;

% ================= VẼ KẾT QUẢ =================
figure('Position',[100 100 900 500]);

subplot(3,1,1);
u0 = generatePulse(md, 0, tau, 0);
plot(tau, u0, 'LineWidth', 1.5);
title('p(t) – xung RRC cơ sở');
xlabel('Time (s)'); ylabel('Amplitude'); grid on;

subplot(3,1,2);
plot(tau, a_t, 'LineWidth', 1.5);
title('a(t) – 1 burst (tổng hợp từ các xung RRC nhân hệ số a_k)');
xlabel('Time (s)'); ylabel('Amplitude'); grid on;

subplot(3,1,3);
t_display = t_u(1:length(a_t)*2);   % hiển thị 2 burst đầu
plot(t_display, u_t(1:length(a_t)*2), 'LineWidth', 1.5);
title('u(t) – tín hiệu phát gồm nhiều burst lặp lại');
xlabel('Time (s)'); ylabel('Amplitude'); grid on;
