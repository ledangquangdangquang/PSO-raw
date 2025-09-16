clc;clear;load('IR_12.mat');load('VA.mat');
A = zeros(25, 7);%tau, phi_1, theta_1, phi_2, theta_2, doppler, alpha 
B = zeros(25, 2);%omega_1 
C = zeros(25, 2);%omega_2 
global md M pos_centers;
tau = (0:4.6414e-12:14999*4.6414e-12); 
md.type = 'RRC'; 
md.Tp = 0.5e-9; 
md.beta = 0.6; 
M = 5; % Number of antennas
load('pos.mat', 'pos_centers')
IR_12_receiver = IR_12(:, 1:M).';
IR_3 = IR_12_receiver; 
IR_4 = IR_12_receiver; 

for i = 1:25 
    fprintf("----- Step %d -----\n", i);
    A(i, 1) = psoT(IR_3, tau);
    fprintf("tau: %f\n", A(i, 1));

    % u = generatePulse(md, A(i, 1), tau, 0);
    u = generatePulse(md, A(i, 1), tau, 2);
    fprintf("Power u: %f\n", calculate_power(u));
    fprintf("Max u: %f\n", max(u));
    
    [A(i, 2), A(i, 3), B(i, :)] = psoOmega_1(u, IR_3, tau);
    fprintf("phi_1: %f (%f)\ntheta_1: %f (%f)\n", A(i, 2), A(i, 2)*180/pi, A(i, 3), A(i, 3)*180/pi);

    A(i, 6) = psoV(u, IR_3, B(i, :), A(i, 3), tau);
    % A(i, 6) =0;
    fprintf("doppler: %f\n", A(i, 6));

    A(i, 7) = alpha_1(u, IR_3, B(i, :), C(i, :), A(i, 3), A(i, 5), A(i, 6), tau);
    fprintf("alpha: %.2f + %.2fi\n", real(A(i, 7)), imag(A(i, 7)));
    fprintf("abs(alpha): %f\n", abs(A(i, 7)));

    IR_3 = calculate_XL_omega_1(u, IR_3, B(i, :), A(i, 3), A(i, 7), A(i, 6));
end