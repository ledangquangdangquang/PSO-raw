function sage_time_invariant_demo()
% SAGE Time-Invariant (virtual array) — single-file demo
% ------------------------------------------------------
% Input (tùy bạn):
%   - Nếu có dữ liệu: chuẩn bị Y (M x Ntau), tau (1 x Ntau, đơn vị s),
%     pos (M x 2, mét), fc (Hz). Đặt USE_SYNTHETIC=false và nạp vào đây.
%   - Nếu chưa có dữ liệu: USE_SYNTHETIC=true để tự sinh dữ liệu tương tự
%     pico-cell (LOS + 3 phản xạ), M=11 (10 điểm vòng tròn + 1 tâm).
%
% Output:
%   - Bảng ước lượng {tau, phi, alpha} cho L tia
%   - Hình Delay–Azimuth spread (ước lượng)
%   - So sánh measured vs reconstructed (một vài cảm biến)

%% ================== CẤU HÌNH CHUNG ==================
USE_SYNTHETIC = true;         % <-- Đổi sang false nếu bạn có dữ liệu thật
c = 3e8;                      % tốc độ ánh sáng
fc = 1.98e9;                  % sóng mang (ví dụ sounder ~1.98 GHz)
lambda = c / fc;
pi =3.141592653589793;
k = 2*pi/lambda;

% Lưới tìm kiếm / lượng tử hoá (theo bài: ~1 ns và 0.05°)
dtau = 1e-9;                  % 1 ns
dphi = 0.05 * pi/180;         % 0.05 độ
L = 20;                       % số tia tối đa (giống Hình 13)
num_init = L;                 % lấy L đỉnh cho khởi tạo
max_iters = 12;               % số vòng SAGE

rng(0); % cố định ngẫu nhiên

%% ================== DỮ LIỆU: SYNTHETIC or LOAD ==================
if USE_SYNTHETIC
    % --- Geometry mảng ảo: 10 điểm vòng + 1 tâm ---
    M = 11;
    R = 0.5;                  % bán kính vòng 0.5 m (khoảng cách ≈ 0.5 m)
    pos = zeros(M,2);
    for m = 1:10
        ang = 2*pi*(m-1)/10;
        pos(m,:) = R*[cos(ang), sin(ang)];
    end
    pos(11,:) = [0,0];        % tâm

    % --- Trục trễ ---
    Ntau = 2048;              % số mẫu trễ
    tau0 = 0;                 % bắt đầu
    tau = tau0 + (0:Ntau-1)*dtau;

    % --- Tập tia thật (ground truth): LOS + 3 phản xạ ---
    GT.L = 4;
    GT.tau = [50, 78, 113, 145]*dtau;                % s
    GT.phi = ( [20, 60, 195, 310] ) * pi/180;        % rad (0°..360°)
    GT.alpha = db2mag([-0, -6, -10, -12]).*exp(1j*2*pi*rand(1,GT.L));

    % --- Dạng xung/kênh theo trễ: dùng pulse hẹp (gần-Dirac) ---
    pulse = exp(-(((-8:8)/2).^2)); pulse = pulse/sum(pulse); % 17 taps
    Y = zeros(M, Ntau);
    for l = 1:GT.L
        a = steering(pos, k, GT.phi(l));     % (M×1)
        idx = nearest_index(tau, GT.tau(l));
        ytap = zeros(1,Ntau);
        % chèn xung tại idx
        sidx = max(1, idx-8) : min(Ntau, idx+8);
        pidx = (sidx - idx) + 9;             % map 1..17
        ytap(sidx) = pulse(pidx);
        Y = Y + GT.alpha(l) * (a * ytap);
    end
    % --- Nhiễu ---
    SNR_dB = 25;
    sigP = mean(abs(Y(:)).^2);
    nP = sigP / db2mag(SNR_dB)^2;
    Y = Y + sqrt(nP/2)*(randn(size(Y)) + 1j*randn(size(Y)));
else
    % ==== TỰ NẠP DỮ LIỆU CỦA BẠN VÀO ĐÂY ====
    load('your_measurement.mat', 'Y', 'tau', 'pos', 'fc');  %#ok<UNRCH>
    [M, Ntau] = size(Y);
    c = 3e8; lambda = c/fc; k = 2*pi/lambda;
end

%% ================== LƯỚI GÓC VÀ BEAMFORMING PRECOMP ==================
phi_grid = 0:dphi:(2*pi - dphi);      % [0, 360°)
Nphi = numel(phi_grid);
A = zeros(M, Nphi);                    % steering dictionary (narrowband)
for ip = 1:Nphi
    A(:,ip) = steering(pos, k, phi_grid(ip));
end
% Chuẩn hoá cột cho fair correlation
A = A ./ vecnorm(A);

%% ================== KHỞI TẠO: SIC TRÊN LƯỚI (tau,phi) ==================
% Noncoherent power map: P(tau,phi) = || A(phi)^H * Y(:,tau) ||^2
% Ta tìm lần lượt các đỉnh, mỗi lần trừ đóng góp tia vừa chọn (SIC)
Rem = Y;  % residual
cand_tau = zeros(1, num_init);
cand_phi = zeros(1, num_init);
cand_alpha = zeros(1, num_init);

for l = 1:num_init
    % Tìm đỉnh
    [tau_idx, phi_idx, ~] = find_peak_tau_phi(Rem, A);
    cand_tau(l) = tau(tau_idx);
    cand_phi(l) = phi_grid(phi_idx);

    % Ước lượng alpha LS tại (tau_idx, phi_idx)
    a = A(:, phi_idx);
    ycol = Rem(:, tau_idx);
    alpha_est = (a' * ycol) / (a' * a);
    cand_alpha(l) = alpha_est;

    % Trừ đóng góp
    Rem(:, tau_idx) = Rem(:, tau_idx) - alpha_est * a;
end

% Gộp thành cấu trúc các tia
paths.tau   = cand_tau(1:L);
paths.phi   = cand_phi(1:L);
paths.alpha = cand_alpha(1:L);
paths.active = true(1,L);   % cho phép tắt tia quá yếu (nếu cần)

%% ================== SAGE: COORDINATE-WISE UPDATES ==================
for it = 1:max_iters
    for l = 1:L
        if ~paths.active(l), continue; end

        % Tín hiệu còn lại khi bỏ tia l
        Y_res = Y - reconstruct_from_paths(paths, A, tau, l);

        % ---- Cập nhật phi_l: maximize |a(phi)^H * Y_res(:, tau_idx_l)|
        [~, tau_idx_l] = min(abs(tau - paths.tau(l)));
        ycol = Y_res(:, tau_idx_l);
        phi_new = argmax_phi(A, ycol, phi_grid);
        paths.phi(l) = phi_new;

        % ---- Cập nhật tau_l: search local neighborhood (±4 dtau)
        a_l = steering(pos, k, paths.phi(l));
        a_l = a_l / norm(a_l);
        tau_idx0 = nearest_index(tau, paths.tau(l));
        win = (tau_idx0-4):(tau_idx0+4);
        win = win(win>=1 & win<=numel(tau));
        tau_new = paths.tau(l);
        best_val = -inf;
        for ti = win
            val = abs(a_l' * Y_res(:,ti));
            if val > best_val
                best_val = val;
                tau_new = tau(ti);
            end
        end
        paths.tau(l) = tau_new;

        % ---- Cập nhật alpha_l (LS)
        [~, tau_idx_l] = min(abs(tau - paths.tau(l)));
        ycol = Y_res(:, tau_idx_l);
        a_l = steering(pos, k, paths.phi(l));
        alpha_new = (a_l' * ycol) / (a_l' * a_l);
        paths.alpha(l) = alpha_new;

        % (tuỳ chọn) bỏ các tia quá yếu
        if abs(paths.alpha(l)) < 1e-3 * max(abs([paths.alpha]))
            paths.active(l) = false;
        end
    end
    fprintf('Iter %2d: %d active paths\n', it, sum(paths.active));
end

%% ================== KẾT QUẢ & VIZ ==================
% Bảng kết quả
tau_ns = 1e9 * paths.tau(:);
phi_deg = mod(rad2deg(paths.phi(:)), 360);
alpha_db = mag2db(abs(paths.alpha(:)));

T = table(tau_ns, phi_deg, alpha_db, 'VariableNames', {'tau_ns','phi_deg','alpha_dB'});
T = sortrows(T, 'alpha_dB', 'descend');
disp('--- Estimated Paths (sorted by |alpha|):');
disp(T(1:min(12,height(T)), :));  % show top 12

% Delay–Azimuth Spread (ước lượng)
DS = zeros(numel(tau), Nphi);
for l = 1:L
    if ~paths.active(l), continue; end
    [~, ti] = min(abs(tau - paths.tau(l)));
    [~, pi] = min(abs(phi_grid - paths.phi(l)));
    DS(ti, pi) = DS(ti, pi) + abs(paths.alpha(l))^2; % tổng Dirac theo tia
end

figure('Name','Delay–Azimuth Spread'); 
imagesc(rad2deg(phi_grid), 1e9*tau, 10*log10(DS + eps));
axis xy; xlabel('\phi (deg)'); ylabel('\tau (ns)');
title('Estimated Delay–Azimuth Spread (dB)'); colorbar;

% So sánh measured vs reconstructed tại vài cảm biến
Yhat = reconstruct_from_paths(paths, A, tau, []);
m_show = [1, 3, 5, 11];
figure('Name','Measured vs Reconstructed (một vài cảm biến)');
for i = 1:numel(m_show)
    m = m_show(i);
    subplot(numel(m_show),1,i);
    plot(1e9*tau, 20*log10(abs(Y(m,:))+eps), 'LineWidth', 1); hold on;
    plot(1e9*tau, 20*log10(abs(Yhat(m,:))+eps), '--', 'LineWidth', 1);
    ylabel(sprintf('Ch%d (dB)', m));
    if i==1, title('Measured (solid) vs Reconstructed (dashed)'); end
    if i==numel(m_show), xlabel('\tau (ns)'); end
    grid on;
end

% (Nếu synthetic) In ra GT để bạn so
if USE_SYNTHETIC
    GT_table = table(1e9*GT.tau(:), mod(rad2deg(GT.phi(:)),360), mag2db(abs(GT.alpha(:))), ...
        'VariableNames', {'tau_ns','phi_deg','alpha_dB'});
    disp('--- Ground Truth (synthetic):');
    disp(GT_table);
end

end % ===== end main =====


%% ================== HÀM PHỤ TRỢ ==================

function a = steering(pos, k, phi)
% Steering vector (narrowband) cho mảng phẳng 2D với hướng azimuth phi
% pos: (M x 2) [m], k: wavenumber, phi [rad]
u = [cos(phi); sin(phi)];        % vector đơn vị theo phi
phase = k * (pos * u);           % (M x 1)
a = exp(1j * phase);             % (M x 1)
end

function [idx_tau, idx_phi, peakval] = find_peak_tau_phi(Y, A)
% Tìm đỉnh theo lưới (tau,phi) bằng noncoherent beamforming power
% Y: (M x Ntau), A: (M x Nphi) steering dictionary (chuẩn hoá cột)
[~, Ntau] = size(Y);
Nphi = size(A,2);
peakval = -inf; idx_tau = 1; idx_phi = 1;

% Ta có thể tăng tốc bằng FFT/gộp, nhưng ở đây brute-force tối giản
for t = 1:Ntau
    y = Y(:,t);
    % matched filter theo phi: p(phi) = |A^H y|^2
    bf = abs(A' * y).^2;   % (Nphi x 1)
    [val, ip] = max(bf);
    if val > peakval
        peakval = val;
        idx_phi = ip;
        idx_tau = t;
    end
end
end

function idx = nearest_index(vec, x)
[~, idx] = min(abs(vec - x));
end

function phi_new = argmax_phi(A, ycol, phi_grid)
% Tìm phi tối ưu (max |a(phi)^H y|) trên lưới đã dựng
bf = abs(A' * ycol);
[~, ip] = max(bf);
phi_new = phi_grid(ip);
end

function Yhat = reconstruct_from_paths(paths, A, tau, skip_l)
% Tái tạo Y từ các tia đã ước lượng
% paths: struct (tau,phi,alpha,active), A: (M x Nphi), tau: (1xNtau)
% skip_l: chỉ số tia cần bỏ qua khi tính residual (để cập nhật tia đó)
M = size(A,1);
Ntau = numel(tau);
Yhat = zeros(M, Ntau);
for l = 1:numel(paths.tau)
    if ~paths.active(l), continue; end
    if ~isempty(skip_l) && (isscalar(skip_l) && l==skip_l), continue; end
    [~, ti] = min(abs(tau - paths.tau(l)));
    % steering gần nhất trên lưới phi:
    phi = paths.phi(l);
    % nội suy nhỏ có thể dùng, nhưng ở đây dùng lưới trực tiếp:
    [~, ip] = min(abs(wrapTo2Pi(get_phi_grid(A)) - wrapTo2Pi(phi)));
    a = A(:, ip);
    Yhat(:, ti) = Yhat(:, ti) + paths.alpha(l) * a;
end
end

function phi_grid = get_phi_grid(A)
% Lấy phi_grid từ kích thước A bằng persistent (đặt khi build A)
% Ở đây đành giữ một biến persistent để lưu
persistent cache_phi_grid
if isempty(cache_phi_grid)
    % placeholder: ta không biết phi_grid ở đây; để an toàn trả lưới 0..2π
    % (không dùng trong reconstruct nếu đã có ip khớp sẵn)
    phi_grid = linspace(0,2*pi,size(A,2)+1); phi_grid(end)=[];
else
    phi_grid = cache_phi_grid;
end
end
