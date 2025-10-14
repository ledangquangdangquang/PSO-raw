clc;clear;load('IR_12.mat');load('VA.mat');hold on;title('Điểm thu phát');grid('on');
%% LOCATION

pos_centers = [0:0.025:(0.025*9); zeros(1,numel( 0:0.025:(0.025*9)))];

M = 10; % Number of antens
startIndexAntenRx = 1;
endIndexAntenRx = startIndexAntenRx+M-1;
Tx = [-used_VAs{1,1}(1,1)  used_VAs{1,1}(2,1)];
%% PLOT
plot(Tx(1), Tx(2), 'bo', 'MarkerSize', 5, 'MarkerFaceColor','r');
plot(pos_centers(1, startIndexAntenRx:endIndexAntenRx), pos_centers(2, startIndexAntenRx:endIndexAntenRx), 'bo', 'MarkerSize', 5, 'MarkerFaceColor','b');
% plot(0, 0, 'bo', 'MarkerSize', 5, 'MarkerFaceColor','c');
legend('Phát','Thu');
% legend('Phát','Thu', 'Gốc tọa độ');
%% Tính toán khoảng cách (tối ưu)
x_tx = Tx(1);
y_tx = Tx(2);

% Lấy toạ độ Rx, đảo ngược thứ tự (nếu muốn giống như code gốc)
x_rx = flip(pos_centers(1, startIndexAntenRx:endIndexAntenRx));
y_rx = flip(pos_centers(2, startIndexAntenRx:endIndexAntenRx));

% Khoảng cách Tx -> Rx
d = hypot(x_tx - x_rx, y_tx - y_rx);    % 1x10
d_cm = 100 * d;

% Khoảng cách Rx liền kề
d_lk = hypot(diff(x_rx), diff(y_rx));   % 1x9
d_lk_cm = 100 * d_lk;

% Chênh lệch khoảng cách Tx->Rx
delta_r = diff(d);                      % 1x9
delta_r_cm = 100 * delta_r;

% Góc gần đúng (xa trường): phi ≈ acos(delta_r/d_lk)
phi = acos(delta_r ./ d_lk);
phi_deg = phi * 180/pi;

%% In kết quả
disp('-----Khoảng cách từ Tx đến 10 Rx-----');
for i = 1:10
    fprintf('r_%d = %.3f cm\n', i, d_cm(i));
end

disp('-----Khoảng cách giữa Rx liền kề-----');
for i = 1:9
    fprintf('rx_%d và rx_%d = %.3f cm\n', i, i+1, d_lk_cm(i));
end

disp('-----Chênh lệch khoảng cách từ 2 Rx liên tiếp đến Tx-----');
for i = 1:9
    fprintf('r_%d - r_%d = %.3f cm\n', i+1, i, delta_r_cm(i));
end

disp('-----------Góc (xấp xỉ) ----------');
for i = 1:9
    fprintf('phi_%d = %.6f rad (%.3f độ)\n', i+1, phi(i), phi_deg(i));
end
