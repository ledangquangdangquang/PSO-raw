function global_best_position = psoV(u, IR_3, omega_1, theta_1, tau)
% Initialize the PSO with your parameters and search space
rng(5);
% Chon cac thong so cua thuat toan PSO
num_particles = 50; % So luong hat trong bay
num_iterations = 1000; % So lan lap
% Chon khong gian tim kiem cho V
search_space_min = -300; % Gia tri toi thieu cua V
search_space_max = 300; % Gia tri toi da cua V

% <<< SỬA LỖI 1: Tính V_max một lần ở đây
V_max = search_space_max - search_space_min;

% Khoi tao van toc va vi tri cua cac hat
particle_velocities = (rand(num_particles, 1) - 0.5) * 2 .* V_max;
particle_positions = search_space_min + rand(num_particles, 1) .* V_max;
% Khoi tao Vi tri tot nhat Ca nhan va Gia tri muc tieu
personal_best_positions = particle_positions;
personal_best_objectives = zeros(num_particles, 1);
for i = 1:num_particles
    personal_best_objectives(i) = objective_function_v(u, personal_best_positions(i), IR_3, omega_1, theta_1, tau);
end
% Khoi tao Vi tri tot nhat Toan cau va Gia tri muc tieu
[global_best_objective, global_best_index] = max(personal_best_objectives);
global_best_position = personal_best_positions(global_best_index, :);
% Khoi tao cac tham so PSO
w = 0.5; % Trong so quan tinh
c1 = 2; % He so nhan thuc
c2 = 2; % He so xa hoi
previous_global_best_objective = global_best_objective;

% <<< SỬA LỖI 2: Chuẩn bị vector để lưu lịch sử, thay vì vẽ trong vòng lặp
history_global_best = zeros(1, num_iterations);

% PSO Main Loop
objectives = zeros(num_particles, 1);
count = 0;
for iteration = 1:num_iterations
    % Cap nhat Vi tri va Van toc
    random_global_best = rand(num_particles, 1) .* (global_best_position - particle_positions);
    random_personal_best = rand(num_particles, 1) .* (personal_best_positions - particle_positions);
    particle_velocities = w * particle_velocities + c1 * random_personal_best + c2 * random_global_best;
    
    % <<< SỬA LỖI 1: Giới hạn vận tốc đúng
    particle_velocities = max(min(particle_velocities, V_max), -V_max);

    % Cap nhat vi tri cua cac hat dua tren van toc
    particle_positions = particle_positions + particle_velocities;
    % Kep Vi tri cac hat vao Khong gian tim kiem
    particle_positions = max(min(particle_positions, search_space_max), search_space_min);
    % Danh gia ham muc tieu cho tung hat
    for i = 1 : num_particles
        objective_value_v = objective_function_v(u, particle_positions(i), IR_3, omega_1, theta_1, tau);
        objectives(i) = objective_value_v;
    end
    % Cap nhat Vi tri Ca nhan tot hat
    update_indices = objectives > personal_best_objectives;
    personal_best_positions(update_indices, :) = particle_positions(update_indices, :);
    personal_best_objectives(update_indices) = objectives(update_indices);
    % Cap nhat Vi tri Toan cau tot nhat
    [max_personal_best, max_index] = max(personal_best_objectives);
    
    % <<< SỬA LỖI 2: Chỉ lưu lại giá trị, không vẽ
    history_global_best(iteration) = global_best_objective;

    if max_personal_best > global_best_objective
        global_best_objective = max_personal_best;
        global_best_position = personal_best_positions(max_index, :);
    end
    
    % Kiem tra dieu kien dung
    diff = abs(global_best_objective - previous_global_best_objective);
    if diff <= 1e-12
        count = count + 1;
    else
        count = 0;
    end
    previous_global_best_objective = global_best_objective;
    if count >= 50
        % Cắt bớt phần chưa dùng của vector lịch sử trước khi thoát
        history_global_best = history_global_best(1:iteration); 
        break;
    end
end

% <<< SỬA LỖI 2: Vẽ đồ thị MỘT LẦN sau khi vòng lặp kết thúc
% figure; % Tạo một cửa sổ hình mới
% plot(history_global_best);
% title('Sự hội tụ của giá trị mục tiêu theo từng vòng lặp');
% xlabel('Số vòng lặp');
% ylabel('Giá trị mục tiêu tốt nhất toàn cục');
% grid on;

end