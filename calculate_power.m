function power_u = calculate_power(u)
    % Tính toán công suất của tín hiệu u(t)
    
    % Tính bình phương của mỗi mẫu của tín hiệu
    squared_signal = abs(u).^2; % Sử dụng hàm abs để lấy giá trị tuyệt đối và bình phương
    
    % Tính tổng bình phương của mọi mẫu
    sum_squared_signal = sum(squared_signal);
    
    % Tính tổng số mẫu
    N = length(u);
    
    % Tính công suất: công suất = tổng bình phương / số mẫu
    power_u = sum_squared_signal / N;
end