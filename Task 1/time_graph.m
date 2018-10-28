% plot of time 
x = 50;
v1 = 1:x;
v2 = 1:x;
v3 = 1:x;
for k = 10:10:(10*x)
    A = (c-d) .* (rand(k, k)+c + 1i*(rand(k, k)+c));
    b = (c-d) .* (rand(k, 1)+c + 1i*(rand(k, 1)+c));

    tic 
    precise_result = A\b;
    v1(k/10)=toc;

    tic
    c_result = GEPP_cmplx_c(A, b);
    v2(k/10)=toc;

    tic 
    my_result = GEPP_cmplx(A, b);
    v3(k/10)=toc;
end

f = figure;
plot(10:10:10*x, v1 ,'r', 10:10:10*x, v2, 'g' , 10:10:10*x, v3, 'b');
title("Wykres rozmiaru macierzy do czasu wykonania");
legend({"Funkcja biblioteczna", "GEPP w Matlabie", "GEPP w C"}, 'Location', 'northwest');
xlabel("[n], gdzie macierz jest nxn");
ylabel("[s]");