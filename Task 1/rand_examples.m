
% interval -> [c, d]
c = -1e6;
d = -c;

n = 1200; % matrix size

A = (c-d) .* (rand(n, n)+c + 1i*(rand(n, n)+c));
b = (c-d) .* (rand(n, 1)+c + 1i*(rand(n, 1)+c));

tic 
precise_result = A\b;
toc;

tic
c_result = GEPP_cmplx_c(A, b);
toc

tic 
my_result = GEPP_cmplx(A, b);
toc

f = figure;
subplot(2, 1, 1);
plot(sort(abs(my_result - precise_result)), 'o');
title("Implementacja Matlab");

subplot(2, 1, 2);
plot(sort(abs(precise_result - c_result)), 'o');
title("Implementacja C");
f;
