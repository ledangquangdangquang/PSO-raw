function XL = calculate_XL_omega_2(u, IR_12, omega_2, theta_2, alpha, v)
 s = calculate_s_omega_2(u, omega_2, theta_2, alpha, v);
 XL = IR_12 - s;
end