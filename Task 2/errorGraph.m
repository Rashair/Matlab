func = @(x,y) tan(atan(x^2 + y)*x)*sin(y-x);
nMin = 4;
nMax = 10;
meanError = zeros(1, nMax-nMin+1);
for i = nMin:nMax
    [error, ~] = squarePolynInterpol(func, i);
    meanError(i - nMin + 1) = error;
end
plot(nMin:nMax, meanError);

func_text = func2str(func);
func_text = func_text(7:strlength(func_text));
title("f = " + func_text);