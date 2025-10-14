clc;clear
% ================== THÔNG SỐ XUNG ==================
md.type = 'RRC';
md.Tp   = 0.5e-9;      % độ rộng xung (0.5 ns)
md.beta = 0.6;         % hệ số roll-off

N  = 15000;            % tổng số mẫu quan sát
Ts = 4.6414e-12;       % chu kỳ lấy mẫu (s)
tau = (0:N-1)*Ts;      % trục thời gian cố định

y = zeros(10, 15000);
tau_delay = linspace(tau(655), tau(14334), 5);
phi       = [27 64 103 149 172] * pi/180;
alpha     = [2+3j, -1.5+0.8j, 0.6-2.4j, -3-1.2j, 1.7+4.5j];
dopller   = 0;
for i = 1:5
    y = y + genPath(tau_delay(i), phi(i), alpha(i), dopller);
end
%% ----------PLOT------------
M = 10;
figure;
for i = 1:M
    subplot(ceil(M/2), 2, i);
    plot(abs(y(i, :)));
end
sgtitle(sprintf('IR_{12}for {%d} antennas', M));
