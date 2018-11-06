func = @(x,y) tan(atan(x^2 + y)*x)*sin(y-x);
nMin = 5;
nMax = 200;
time = zeros(nMax/nMin);
for i = nMin:nMin:nMax
    tic
    squarePolynInterpol(func, i);
    time(i/nMin) = toc;
end
plot(nMin:nMin:nMax, time);

func_text = func2str(func);
func_text = func_text(7:strlength(func_text));
title("f = " + func_text);
xlabel("n");
ylabel("s");
