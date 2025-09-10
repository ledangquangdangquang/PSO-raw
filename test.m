clc; clear; close all;

% --- Tham số ---
Nbits = 6;      % số bit truyền
sps   = 8;      % số mẫu trên mỗi symbol (oversampling)
span  = 6;      % filter span (độ dài bộ lọc tính theo symbol)
alpha = 0.5;    % roll-off factor

% --- Tạo dãy bit ngẫu nhiên ---
bits = randi([0 1], 1, Nbits);
symbols = 2*bits - 1;   % BPSK: 0 -> -1, 1 -> +1

% --- Tín hiệu xung vuông (chưa lọc) ---
upsampled = upsample(symbols, sps);

% --- Bộ lọc Raised Cosine ---
rcFilter = rcosdesign(alpha, span, sps, 'normal');

% --- Tín hiệu sau RC filter ---
signal_rc = conv(upsampled, rcFilter, 'same');

% --- Vẽ kết quả ---
t = (0:length(upsampled)-1)/sps;

figure;
plot(t, upsampled, 'k--', 'LineWidth', 1); hold on;
plot(t, signal_rc, 'b', 'LineWidth', 2);
stem((0:Nbits-1), symbols, 'r', 'filled', 'LineWidth', 1.5);
grid on;
xlabel('Time (symbols)');
ylabel('Amplitude');
legend('Xung vuông (chưa lọc)','Sau RC filter','Symbols gốc');
title('So sánh tín hiệu trước và sau bộ lọc RC');
