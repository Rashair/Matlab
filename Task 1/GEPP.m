function [x] = GEPP(A, b)
% Function solves linear system of equations Ax = b in the field of real
% numbers using the Gauss Elimination with Partial Pivoting method
% Input:
%   A - matrix of size nxn
%   b - vertical vector of size nx1
% Output: 
%   x - vertical vector of size nx1
% Calling example:
%   A = [1 2;3 4];
%   b = [1 2]';
%   x = GEPP(A, b)
%   Result: [0 0.5]'   

if(nargin ~= 2)
    error("Bledna ilosc argumentow wejsciowych")
elseif(nargout ~= 1)
    error("Bledna ilosc argumentow wyjsciowych")
end

n = size(A, 1);
if size(A, 2) ~= n
    error("Macierz A nie jest kwadratowa")
elseif size(b, 1) ~= n
    error("Rozmiar wektora b jest inny niz rozmiar macierzy A")
elseif det(A) == 0
    error("Wyznacznik macierzy A jest równy 0")
end

Ab_system = [A b];
for it = 1:n-1
    % search for row of maximal current pivot
    [~, rown] = max(abs(Ab_system(it:n, it)));
    rown = rown + it - 1;
    % swap current row with maximal
    Ab_system([it rown], :) = Ab_system([rown it], :);

    % do Gaus elimination
    Ab_system(it+1:n, :) = Ab_system(it+1:n, :) - (Ab_system(it, :).*(Ab_system(it+1:n, it)./Ab_system(it,it)));
end

% getting final results
for it = n:-1:1
    Ab_system(it, :) = Ab_system(it, :)./Ab_system(it,it);
    Ab_system(it-1:-1:1, :) = Ab_system(it-1:-1:1, :) - (Ab_system(it, :).*(Ab_system(it-1:-1:1, it)));
end

x = Ab_system(:, n+1);
end