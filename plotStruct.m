clc;clear;load('IR_12.mat');load('VA.mat');load('pos.mat');
hold on;
title('Điểm thu phát');
grid('on');
VAtmp = used_VAs{1,1}(:,1);
VAtmp(1,1) = -used_VAs{1,1}(1,1);
plot(VAtmp(1,1), used_VAs{1,1}(2,1), 'bo', 'MarkerSize', 5, 'MarkerFaceColor','r');
plot(pos_centers(1, 11:20), pos_centers(2, 11:20), 'bo', 'MarkerSize', 5, 'MarkerFaceColor','b');
plot(0, 0, 'bo', 'MarkerSize', 5, 'MarkerFaceColor','c');
legend('Phát','Thu', 'Gốc tọa độ');
%% Tính toán khoảng cách
x_tx =VAtmp(1,1);
y_tx =used_VAs{1,1}(2,1);
x_rx =pos_centers(1, 11:20);
y_rx =pos_centers(2, 11:20);

d = flip(sqrt((x_tx-x_rx).^2 + (y_tx - y_rx).^2));

disp('-----Khoảng cách từ Tx đến 10 Rx-----');
for i = 1:10
    fprintf('r_%d = %f cm\n', i, 100*d(i));
end
disp('-----Khoảng cách giữa Rx liền kề-----');
for i = 1:9
    d_lk(i) = flip(sqrt((x_rx(i)-x_rx(i+1)).^2 + (y_rx(i) - y_rx(i+1)).^2));
    fprintf('rx_%d và rx_%d = %f cm\n', i, i+1, 100*d_lk(i));
end
disp('-----Chênh lệch khoảng cách từ 2 anten thu liên tiếp đến anten phát-----')
for i = 1:9
    delta_r(i) = d(i+1) - d(i);
    fprintf('r_%d - r_%d = %f cm\n', i+1, i, 100*delta_r(i));
end
disp('-----------Góc----------')
phi = acos(delta_r ./ d_lk);
for i = 1:9
    fprintf('phi_%d = %f rad (%f độ)\n', i+1, phi(i), phi(i)*180/pi);
end