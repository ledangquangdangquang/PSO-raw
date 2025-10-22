function XL = calculate_XL_omega_1(u, IR_12, omega_1, theta_1, alpha, v, tau_delay)
Ts      = 2.6667e-11;
s = calculate_s_omega_1(u, omega_1, theta_1, alpha, v);
tyle = max(abs(s(1,:))) / abs(IR_12(1, round(tau_delay/ Ts) + 1));
s = s / tyle;
XL = IR_12 - s;
%% Log Full anten IR12 and s
global M;
% tau1 = (0:4.6414e-12:14999*4.6414e-12);
N       = 4310;      % Number of sample
Ts      = 2.6667e-11; % Sampling period
tau1     = (0:N-1)*Ts;
figure;
for i = 1:M
    subplot(ceil(M/2), 2, i);
    plot(tau1, abs(IR_12(i, :))); hold on;
    plot(tau1, abs(s(i, :)), '--');
    % plot(tau1, real(IR_12(i, :))); hold on;
    % plot(tau1, real(s(i, :)), '--');
    % plot(tau1, real(IR_12(i, :))); hold on;
    % plot(tau1, real(s(i, :)), '--');
    legend({'IR_{12}', sprintf('s_{%d}', i)});
    title(sprintf('anten {%d}: IR_{12} and s', i));
end
%sgtitle(sprintf('IR_{12} and s for {%d} antennas', M));
%% Log Full anten IR12 and IR3 (IR12 is IR3 previous)
% figure;
% for i = 1:M
%     subplot(ceil(M/2), 2, i);
%     plot(tau1, real(IR_12(i, :))); hold on;
%     plot(tau1, real(XL(i, :)), '--');
%     legend({'IR_{12}', 'IR_3'});
%     title(sprintf('anten {%d}: IR_{12} and IR_3', i));
% end
% hold off;
% sgtitle(sprintf('IR_{12} and IR_3 for {%d} antennas', M));
%% Log Full s in one
% figure;
% for i = 1:M
%     plot(tau1, real(s(i, :))); hold on;
% end
end
