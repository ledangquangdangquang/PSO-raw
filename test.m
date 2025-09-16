tau = (0:4.6414e-12:14999*4.6414e-12); 
ai = 1.626231880088694e-08;
md.type = 'RRC'; 
md.Tp = 0.5e-9; 
md.beta = 0.6; 

u0 = generatePulse(md, ai, tau, 0);
u1 = generatePulse(md, ai, tau, 1);
u2 = generatePulse(md, ai, tau, 2);
u3 = generatePulse(md, ai, tau, 3);

hold on;
% plot(tau, u0);
% plot(tau, u1);
plot(tau, u2);
% plot(tau, u3);
% legend('u0', 'u1', 'u2', 'u3');