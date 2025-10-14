function s = calculate_s_omega_1(u, omega_1, theta_1, alpha, v)
    c = calculate_c_omega_1(omega_1, theta_1); % 10x1
    s = c * alpha * exp(1j*2*pi*v) * u ; % 10x15000

    % ---Log---
%    disp('--- s calculator ---');
%    fprintf("alpha = %.10f + %.10fi\n", real(alpha), imag(alpha));
%    fprintf("exp(j2piv) = %.5f + %.5fi\n", real(exp(1j*2*pi*v)), imag(exp(1j*2*pi*v)));
%    fprintf("Max u: %f\n", max(u));
%    fprintf("Max c: %f\n", max(c));
end
