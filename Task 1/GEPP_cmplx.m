function [x] = GEPP_cmplx (A, b)
% Function solves linear system of equations Ax = b in the field of complex
% numbers using the Gauss Elimination with Partial Pivoting method
% Input:
%   A - complex matrix of size nxn
%   b - complex vertical vector of size nx1
% Wyjscie: 
%   x - complex vertical vector of size nx1
% Calling example:
%   A = [1+i 2+i;3+i 4+i];
%   b = [1+i 2+i].';
%   x = GEPP(A, b)
%   Result: [0.0000+1.5000i 0.5000-1.5000i]'
if(nargin ~= 2)
    error("Bledna ilosc argumentow wejsciowych")
elseif(nargout ~= 1)
    error("Bledna ilosc argumentow wyjsciowych")
end

A_real = real(A);
A_imag = imag(A);
A_system = [A_real -A_imag; A_imag A_real];
b_system = [real(b); imag(b)];
x_system = GEPP(A_system, b_system);

x_size = max(size(x_system)) / 2;

x = x_system(1:x_size) + 1i*x_system(x_size+1:x_size*2);

end
