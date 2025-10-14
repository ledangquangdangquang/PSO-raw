% function [theta_1, phi_1, omega_1] = psoOmega_1(u, IR_3, tau)
function [phi_1,theta_1, omega_1] = psoOmega_1(u, IR_3, tau)
    rng(0); % Sử dụng hạt giống ngẫu nhiên cố định
    % Thiết lập các tham số PSO và không gian tìm kiếm
    num_particles = 50; % Số lượng hạt trong bầy
    num_iterations = 1000; % Số lần lặp
    search_space_min = [-pi, 0]; % Giá trị tối thiểu của 4 biến
    search_space_max = [pi, pi]; % Giá trị tối đa của 4 biến
    % Khởi tạo vận tốc và vị trí của các hạt
    particle_velocities = (rand(num_particles, 2) - 0.5) * 2 .* (search_space_max - search_space_min);
    particle_positions = search_space_min + rand(num_particles, 2) .*  (search_space_max - search_space_min);
    % Khởi tạo Vị trí Tốt Nhất Cá Nhân và Giá Trị Mục Tiêu
    personal_best_positions = particle_positions;
    personal_best_objectives = zeros(num_particles, 1);
    for i = 1:num_particles
        personal_best_objectives(i) = objective_function_omega_1(u,  personal_best_positions(i, :), IR_3, tau);
    end
    % Khởi tạo Global Best Position và Global Best Objective Value
    [global_best_objective, global_best_index] = max(personal_best_objectives);
    global_best_position = personal_best_positions(global_best_index, :);
    % Khởi tạo các tham số PSO
    w = 0.5; % Trọng số quán tính
    c1 = 2; % Hệ số nhận thức
    c2 = 2; % Hệ số xã hội
    % PSO Main Loop
    objectives = zeros(num_particles, 1);
    for iteration = 1:num_iterations
        % Cập nhật vận tốc và vị trí của các hạt
        random_global_best = rand(num_particles, 2) .* (global_best_position - particle_positions);
        random_personal_best = rand(num_particles, 2) .* (personal_best_positions - particle_positions);
        particle_velocities = w * particle_velocities + c1 * random_personal_best + c2 * random_global_best;
    
        % Giới hạn vận tốc
        particle_velocities = max(min(particle_velocities, search_space_max -search_space_min), -(search_space_max - search_space_min));
    
        % Cập nhật vị trí của các hạt dựa trên vận tốc
        particle_positions = particle_positions + particle_velocities;
    
        % Kẹp vị trí hạt vào không gian tìm kiếm
        particle_positions = max(min(particle_positions, search_space_max), search_space_min);
    
        % Đánh giá hàm mục tiêu cho từng hạt
        for i = 1 : num_particles
            objective_value_1 = objective_function_omega_1(u, particle_positions(i, :), IR_3, tau);
            objectives(i) = objective_value_1;
        end
    
        % Cập nhật vị trí tốt nhất cá nhân
        update_indices = objectives > personal_best_objectives;
        personal_best_positions(update_indices, :) = particle_positions(update_indices, :);
        personal_best_objectives(update_indices) = objectives(update_indices);
        % Cập nhật vị trí tốt nhất toàn cục
        [max_personal_best, max_index] = max(personal_best_objectives);
        % test_global_best_position(iteration) = global_best_objective;
    
        if max_personal_best > global_best_objective
            global_best_objective = max_personal_best;
            global_best_position = personal_best_positions(max_index, :);
        end
        % plot(test_global_best_position);
    
    
    end
    
    % theta_1 = global_best_position(1);
    % phi_1 = global_best_position(2);
    theta_1 = global_best_position(2);
    phi_1 = global_best_position(1);
    omega_1 = [cos(phi_1) * sin(theta_1), sin(phi_1) * sin(theta_1)];
    % objective_value = global_best_objective;
end