get_row = @(x, varargin) x(varargin{:});

% First example

A = gallery('gcdmat',4) + 1i*gallery('chebspec',4,1)
b = get_row(magic(4),':',1) + 1i*get_row(vander(1:4),':', 1)

tic 
precise_result = A\b
toc;

tic
c_result = GEPP_cmplx_c(A, b);
toc

tic 
my_result = GEPP_cmplx(A, b);
toc

blad_C = max(abs(precise_result - c_result))
blad_Matlab = max(abs(my_result - precise_result))

% Second example

A = gallery('frank',4, 1) + 1i*gallery('lehmer',4,1)
b = get_row(hilb(4),':',1) + 1i*get_row(compan(1:5),':', 1)

tic 
precise_result = A\b
toc;

tic
c_result = GEPP_cmplx_c(A, b);
toc

tic 
my_result = GEPP_cmplx(A, b);
toc

blad_C = max(abs(precise_result - c_result))
blad_Matlab = max(abs(my_result - precise_result))


% Third example
A = 1i*invhilb(4)
b = (1:4)'

tic 
precise_result = A\b
toc;

tic
c_result = GEPP_cmplx_c(A, b);
toc

tic 
my_result = GEPP_cmplx(A, b);
toc

blad_C = max(abs(precise_result - c_result))
blad_Matlab = max(abs(my_result - precise_result))


