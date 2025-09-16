# PSO-raw (MATLAB)

Triển khai bằng MATLAB một quy trình ước lượng tham số dùng Particle Swarm Optimization (PSO) cho hệ thống nhiều anten. Quy trình ước lượng tuần tự độ trễ xung, tham số hướng, Doppler và biên độ phức; sau mỗi bước sẽ cập nhật tín hiệu dư (residual).

### Yêu cầu
- MATLAB R2020a hoặc mới hơn (khuyến nghị có Signal Processing Toolbox)
- Hệ điều hành: Windows/Linux/macOS
- Mọi tệp của kho mã nằm cùng một thư mục (thư mục này)

### Tệp dữ liệu
- `IR_12.mat`: Phản hồi xung theo anten (ma trận). Script sử dụng `M` cột đầu.
- `VA.mat`: Dữ liệu bổ sung được nạp trong `all25.m`.
- `pos.mat`: Chứa `pos_centers` dùng để tính đáp ứng mảng anten.

Hãy đảm bảo các tệp này có trong thư mục gốc của dự án.

### Quy trình chính
Chạy `all25.m`. Script thực hiện 25 bước ước lượng nối tiếp:
1. Nạp `IR_12.mat`, `VA.mat`, `pos.mat`. Thiết lập biến toàn cục: số anten `M=5`, mô hình xung `md` (kiểu RRC, `Tp`, `beta`) và lưới thời gian `tau`.
2. Cho mỗi bước (1..25):
   - Ước lượng độ trễ `tau_0` bằng PSO: `psoT(IR_3, tau)`.
   - Tạo xung chuẩn hoá `u = generatePulse(md, tau_0, tau, 2)` và in công suất.
   - Ước lượng tham số hướng bằng PSO: `[phi_1, theta_1, omega_1] = psoOmega_1(u, IR_3, tau)`.
   - Ước lượng Doppler `v` bằng PSO: `psoV(u, IR_3, omega_1, theta_1, tau)`.
   - Ước lượng biên độ phức `alpha` (tỷ lệ đóng dạng): `alpha_1(...)`.
   - Cập nhật kênh dư: `IR_3 = calculate_XL_omega_1(u, IR_3, omega_1, theta_1, alpha, v)`.

Kết quả trung gian được in ra cửa sổ lệnh. `calculate_XL_omega_1` cũng vẽ tín hiệu theo từng anten và thành phần mô hình để kiểm tra.

### Bắt đầu nhanh
1. Mở MATLAB và đặt thư mục làm việc hiện tại tới thư mục dự án này.
2. Đảm bảo có các tệp `IR_12.mat`, `VA.mat`, `pos.mat` trong đây.
3. Chạy:
   ```matlab
   all25
   ```

### Script và hàm chính
- `all25.m`: Điều phối vòng lặp 25 bước ước lượng và ghi log.
- `psoT.m`: PSO ước lượng độ trễ `tau_0` bằng cách cực đại `objective_function_tau`.
- `psoOmega_1.m`: PSO ước lượng góc `[phi_1, theta_1]` và véc-tơ đơn vị `omega_1`, cực đại `objective_function_omega_1`.
- `psoV.m`: PSO ước lượng Doppler `v`, cực đại `objective_function_v`.
- `alpha_1.m`: Tính hệ số biên độ phức dựa trên công suất xung và đáp ứng mảng.
- `calculate_XL_omega_1.m`: Xây dựng tín hiệu mô hình với tham số ước lượng và tính residual `IR_12 - s`; đồng thời vẽ đồ thị chẩn đoán.
- `generatePulse.m`: Tạo xung RC/RRC và đạo hàm; hỗ trợ các chế độ chuẩn hoá (0: không, 1: theo đỉnh, 2: theo năng lượng, 3: theo năng lượng có `tau`).
- `objective_function_tau.m`: Tương quan `u(md, tau_0)` với `IR_3` qua các anten và cộng năng lượng.
- `objective_function_omega_1.m`: Dùng đáp ứng mảng `calculate_c_omega_1` tạo bộ lọc phù hợp và cực đại bình phương độ lớn tích phân.
- `objective_function_v.m`: Thêm nhân tử Doppler `exp(-j 2π v τ)` vào bộ lọc phù hợp và cực đại độ lớn.
- `calculate_c_omega_1.m`: Tạo véc-tơ đáp ứng mảng `c(ω, θ)` từ `pos_centers` cho các anten chỉ số 11..20.
- `calculate_power.m`: Công suất trung bình của một tín hiệu.
- `sigEnergy.m`: Năng lượng tín hiệu (tuỳ chọn có trọng số theo bước `tau`).
- `test.m`: Ví dụ trực quan hoá xung sinh ra và các chế độ chuẩn hoá.

### Biến toàn cục và tham số
- Biến toàn cục sử dụng: `md` (cấu trúc mô hình xung), `M` (số anten), `pos_centers` (hình học mảng anten).
- Giá trị mặc định trong `all25.m`: `M = 5`, `md.type = 'RRC'`, `md.Tp = 0.5e-9`, `md.beta = 0.6`.
- Lưới thời gian: `tau = 0 : 4.6414e-12 : 14999*4.6414e-12` (độ dài 15000).

### Ghi chú và mẹo
- Seed ngẫu nhiên: `psoOmega_1` dùng `rng(0)`, `psoV` dùng `rng(5)` để tái lập.
- Khi chạy `calculate_XL_omega_1` có thể mở cửa sổ đồ thị. Đóng chúng hoặc chỉnh sửa hàm để tắt vẽ nếu chạy headless.
- Nếu thay `M` hoặc `pos_centers`, cần cập nhật `calculate_c_omega_1` (chỉ số anten `11:20`) cho phù hợp.

### Mở rộng và trích dẫn
- Có thể mở rộng để trích xuất đa thành phần bằng cách lặp lại vòng và/hoặc mô hình thêm các đường truyền (`omega_2`, `theta_2`, ...).
- Khi dùng cho mục đích nghiên cứu, vui lòng trích dẫn phương pháp bạn đã điều chỉnh tương ứng.
