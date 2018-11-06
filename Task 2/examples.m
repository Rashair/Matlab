% I example
func = @(x,y) 1 / (sin(x^2) + exp(-x^2 - y^2));
[error, matrix] = squarePolynInterpol(func, 2);

func_text = func2str(func);
func_text = func_text(7:strlength(func_text)); % cut beginning of function text
disp(['f = ', func_text]);

arr = array2table(round(matrix, 5), 'VariableNames',{'num', 'x', 'y', 'p_x_y', 'f_x_y', 'blad_wzgl'});
disp(arr);
%writetable(arr, "table1.xls");

disp(['bladSrKwadratowy = ', mat2str(round(error, 8))]);
fprintf('\n');

%--------------------------------------------------------------

% II example
func = @(x,y) log(1 + (x + y)^2) - cos((x+y) / (1 + (x+y)^2));
[error, matrix] = squarePolynInterpol(func, 2);

func_text = func2str(func);
func_text = func_text(7:strlength(func_text));
disp(['f = ', func_text]);

arr = array2table(round(matrix, 5), 'VariableNames',{'num', 'x', 'y', 'p_x_y', 'f_x_y', 'blad_wzgl'});
disp(arr);
%writetable(arr, "table2.xls");

disp(['bladSrKwadratowy = ', mat2str(round(error, 8))]);
fprintf('\n');

%--------------------------------------------------------------

% III example
func = @(x,y) tan(atan(x^2 + y)*x)*sin(y-x);
[error, matrix] = squarePolynInterpol(func, 2);

func_text = func2str(func);
func_text = func_text(7:strlength(func_text));
disp(['f = ', func_text]);

arr = array2table(round(matrix, 5), 'VariableNames',{'num', 'x', 'y', 'p_x_y', 'f_x_y', 'blad_wzgl'});
disp(arr);
%writetable(arr, "table3.xls");

disp(['bladSrKwadratowy = ', mat2str(round(error, 8))]);
fprintf('\n');
%--------------------------------------------------------------

% IV example
func = @(x,y) sin(27951/256*x*y);
[error, matrix] = squarePolynInterpol(func, 7);

func_text = func2str(func);
func_text = func_text(7:strlength(func_text));
disp(['f = ', func_text]);

x1 = matrix(:, 2);
y1 = matrix(:, 3);
polynomialVal = matrix(:, 4);
funcVal = matrix(:, 5);

subplot(2, 1, 1);
plot3(x1, y1, polynomialVal, '.');
title("Wielomian interpolacyjny");
%view([0 1 0]);


subplot(2, 1, 2);
plot3(x1, y1, funcVal, '.');
title("Funkcja");
%view([0 1 0]);

disp(['bladSrKwadratowy = ', mat2str(round(error, 8))]);
