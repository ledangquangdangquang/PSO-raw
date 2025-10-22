load('RL_grid_corridor.mat');
%% ----------PLOT------------
y = RL(:,1:10).';
M = 10;
figure;
for i = 1:M
    subplot(ceil(M/2), 2, i);
    plot(abs(y(i, :)));
end
sgtitle(sprintf('IR_{12}for {%d} antennas', M));



