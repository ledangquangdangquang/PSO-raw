clc; clear;
load('IR_12.mat'); load('VA.mat'); load('pos.mat');

hold on;
title('Điểm thu phát');
grid on;

% Vẽ điểm phát
VAtmp = used_VAs{1,1}(:,1);
VAtmp(1,1) = -used_VAs{1,1}(1,1);
plot(VAtmp(1,1), used_VAs{1,1}(2,1), 'ro', 'MarkerSize', 6, 'MarkerFaceColor','r');

% Vẽ gốc tọa độ
plot(0, 0, 'co', 'MarkerSize', 6, 'MarkerFaceColor','c');

% Chia màu theo nhóm 10 điểm
numPoints = size(pos_centers,2);
groupSize = 10;
numGroups = ceil(numPoints / groupSize);

colors = lines(numGroups); % bảng màu tự động

legendEntries = cell(1, numGroups);

for g = 1:numGroups
    startIdx = (g-1)*groupSize + 1;
    endIdx   = min(g*groupSize, numPoints);
    
    plot(pos_centers(1,startIdx:endIdx), pos_centers(2,startIdx:endIdx), ...
         'o', 'MarkerSize', 5, 'MarkerFaceColor', colors(g,:), 'MarkerEdgeColor','k');
    
    % Thêm vào legend dạng "Cụm X: start–end"
    legendEntries{g} = sprintf('Cụm %d: %d–%d', g, startIdx, endIdx);
end

legend(['Phát','Gốc tọa độ', legendEntries]);
