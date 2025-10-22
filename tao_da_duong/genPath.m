function s = genPath(tau_delay, phi, alpha, v, tau, md)

    % ================== XÂY DỰNG p(t) ==================
    p_t = generatePulse(md, tau_delay, tau, 0);  % xung RRC cơ sở
    
    % ====== VECTOR HƯỚNG SÓNG OMEGA_0 (2D) ======
    omega_0 = [cos(phi), sin(phi)];   % vì 2D, bỏ trục z
    
    % ====== TÍNH VECTOR HƯỚNG c(phi) ======
    c = calculate_c_omega_2D(omega_0);  % dùng hàm 2D mới
    
    % ====== TÍNH s(t) – CÓ DOPPLER THEO THỜI GIAN ======
    s = c * (alpha .* exp(1j*2*pi*v*tau)) .* p_t;   % (M×N)

end