clc;clear;load('IR_12.mat');load('VA.mat');load('ir12.mat');load('pos_gridpoint_corridor');load('RL_grid_corridor');
global  md M pos_centers ;
% load('pos.mat', 'pos_centers')
% pos_centers = [0:0.025:(0.025*9); zeros(1,numel( 0:0.025:(0.025*9)))];
md.type = 'RRC';
md.Tp   = 0.5e-9;
md.beta = 0.6;
M       = 10;         % Number of antennas
pos_centers = pos(:, 1:M);
paths   = 5;          % Number of paths
%N       = 15000;      % Number of sample
%Ts      = 4.6414e-12; % Sampling period
N       = 4310;      % Number of sample
Ts      = 2.6667e-11; % Sampling period
tau     = (0:N-1)*Ts;
% IR_12_rx = IR_12(:, 1:M).';
% IR_12_rx= y;
IR_12_rx = RL(:, 1:M).';
IR_3    = IR_12_rx;
IR_4    = IR_12_rx;
A       = zeros(paths, 7);  %tau, phi_1, theta_1, phi_2, theta_2, doppler, alpha
B       = zeros(paths, 2);  %omega_1
C       = zeros(paths, 2);  %omega_2
for i = 1:paths
    fprintf("----- Step %d -----\n", i);
    A(i, 1) = psoT(IR_3, tau);
    u = generatePulse(md, A(i, 1), tau, 0);
    [A(i, 2), A(i, 3), B(i, :)] = psoOmega_1(u, IR_3, tau); % Theta     Phi     Omega
    A(i, 6) = psoV(u, IR_3, B(i, :), A(i, 3), tau);
    A(i, 7) = alpha_1(u, IR_3, B(i, :), A(i, 3), A(i, 6), tau);
    IR_3 = calculate_XL_omega_1(u, IR_3, B(i, :), A(i, 3), A(i, 7), A(i, 6));

    %% -------------LOG-------------
    fprintf("tau    : %e\n", A(i, 1));
    fprintf("Power u: %f\n", calculate_power(u));
    fprintf("Max |u|: %f\n", max(u));
    fprintf("phi_1  : %f (%f độ)\ntheta_1: %f (%f độ)\n", A(i, 2), A(i, 2)*180/pi, A(i, 3), A(i, 3)*180/pi);
    fprintf("doppler: %f\n", A(i, 6));
    fprintf("alpha  : %.2f + %.2fi\n", real(A(i, 7)), imag(A(i, 7)));
    fprintf("|alpha|: %f\n", abs(A(i, 7)));
end
