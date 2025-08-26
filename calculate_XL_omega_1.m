function XL = calculate_XL_omega_1(u, IR_12, omega_1, theta_1, alpha, v)
s = calculate_s_omega_1(u, omega_1, theta_1, alpha, v);
XL = IR_12 - s;
%% Log
figure;
tau1 = (0:4.6414e-12:14999*4.6414e-12);

subplot(4, 1, 1); plot(tau1, real(IR_12(:, 1))); title('IR_{12}');
subplot(4, 1, 2); plot(tau1, real(s(:, 1))); title('s');
subplot(4, 1, 3); plot(tau1, real(XL(:, 1))); title('IR_{3}');
subplot(4, 1, 4); 
    plot(tau1, real(IR_12(:, 1))); hold on;
    plot(tau1, real(XL(:, 1)), '--');
    legend({'IR_{12}', 'IR_3'});
    title('IR_{12} and IR_{3}');

end
