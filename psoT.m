function t = psoT(IR_3, tau)% Initialize the PSO with your parameters and search space
% Chọn các thông số của thuật toán PSO
num_particles = 50; % Số lượng hạt trong bầy
num_iterations = 1000; % Số lần lặp

% Chọn không gian tìm kiếm cho tau
search_space_min = 1e-8; % Giá trị tối thiểu của tau
search_space_max = 6e-8; % Giá trị tối đa của tau
% Initialize particle positions within the search space
particle_positions = rand(num_particles, 1) * (search_space_max - search_space_min) + search_space_min;
% Initialize particle velocities (can be set randomly)
particle_velocities = rand(num_particles, 1);
%Initialize Personal Best Positions and Objective Values
personal_best_positions = particle_positions;
personal_best_objectives = arrayfun(@(tau_0) objective_function_tau(tau,  tau_0, IR_3), personal_best_positions);
%Initialize Global Best Position and Objective Value
[global_best_objective, global_best_index] = max(personal_best_objectives);
global_best_position = personal_best_positions(global_best_index);
%Initialize PSO Parameters
w = 0.5; % Inertia weight
c1 = 2; % Cognitive coefficient
c2 = 2; % Social coefficient

%PSO Main Loop
for iteration = 1:num_iterations

    % Update velocities and positions
    particle_velocities = w * particle_velocities + c1 * rand() * (personal_best_positions - particle_positions) + c2 * rand() * (global_best_position - particle_positions);
    particle_positions = particle_positions + particle_velocities;
    % Clip particle positions to the search space
    particle_positions = max(min(particle_positions, search_space_max), search_space_min);
    % Evaluate objective function for each particle
    objectives = arrayfun(@(tau_0) objective_function_tau(tau, tau_0, IR_3), particle_positions);

    % Update personal best positions and global best position
    update_indices = objectives > personal_best_objectives;

    personal_best_positions(update_indices) = particle_positions(update_indices);

    personal_best_objectives(update_indices) = objectives(update_indices);
    [max_personal_best, max_index] = max(personal_best_objectives);
    test_max_personal_best(iteration) = global_best_objective;
    if max_personal_best > global_best_objective
        global_best_objective = max_personal_best;
        global_best_position = personal_best_positions(max_index);
    end
end
figure;
title('Sự hội tụ của global_best_objective');
plot(test_max_personal_best);
objective_value = global_best_objective;
t = global_best_position;
end