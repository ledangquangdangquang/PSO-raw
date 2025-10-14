N = 15000;
Ts = 4.6414e-12;

a = (0:N-1)*Ts;
b = 0:Ts:(N-1)*Ts;

length(a)
length(b)
max(abs(a - b))

