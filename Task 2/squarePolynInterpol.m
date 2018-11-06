function [meanSquaredError, valuesArray] = squarePolynInterpol(func, n)
% Function 'interSquare' interpolates the function 'func' on the area of D: |x| + |y| < 1 
% by dividing it into 4*n^2 congruent triangles.
% Returns matrix 'valuesArray' , and also 'meanSquaredError' which is a value.
% Interpolation points are centers of mass of triangles
%
% Input:
%     func - interpolated function
%     n    - number for dividing area into triangles
% Output:
%     meanSquaredError - value of mean squared error beetween values of 'func' and interpolating
%                        polynomials in centroids of triangles
%     valuesArray      - containing values of 'func', values of interpolation polynomial and 
%                        relative error between both of this values
%
% Calling example:
%  Input:
%     func = @(x,y) 1 / (sin(x^2) + exp(-x^2 - y^2));
%     [error, matrix] = squarePolynInterpol(func, 2);
%  Result:
%     num       x           y         p_x_y      f_x_y     blad_wzgl
%     ___    ________    ________    _______    _______    _________
% 
%      1      0.16667     0.16667      1.025      1.027     0.19216 
%      2      0.33333     0.33333     1.1029      1.097     0.54651 
%      3      0.66667     0.16667    0.94254    0.94915     0.69682 
%      4      0.16667     0.66667     1.5085     1.5352      1.7397 
%      5     -0.16667     0.16667      1.025      1.027     0.19216 
%      6     -0.33333     0.33333     1.1029      1.097     0.54651 
%      7     -0.66667     0.16667    0.94254    0.94915     0.69682 
%      8     -0.16667     0.66667     1.5085     1.5352      1.7397 
%      9     -0.16667    -0.16667      1.025      1.027     0.19216 
%     10     -0.33333    -0.33333     1.1029      1.097     0.54651 
%     11     -0.66667    -0.16667    0.94254    0.94915     0.69682 
%     12     -0.16667    -0.66667     1.5085     1.5352      1.7397 
%     13      0.16667    -0.16667      1.025      1.027     0.19216 
%     14      0.33333    -0.33333     1.1029      1.097     0.54651 
%     15      0.66667    -0.16667    0.94254    0.94915     0.69682 
%     16      0.16667    -0.66667     1.5085     1.5352      1.7397 
% 
% bladSrKwadratowy = 0.00019922


if (nargin ~= 2)
    error("Nieodpowiednia ilosc argumentów wejsciowych.")
end

nInverse = 1/n;
nSquared = n*n;

firstColumnTriangleA = [0, 0];
firstColumnTriangleB = [nInverse, 0];
firstColumnTriangleC = [0, nInverse];

%centers of mass
xCoordinates = zeros(1, 4*nSquared);
yCoordinates = zeros(1, 4*nSquared);
interpolatingPolynomialValues = zeros(1, 4*nSquared);
funcValues = zeros(1, 4*nSquared);
vectorsIt = 1;

polynomialScheme = @(x, y) [1, x, y, x*y, x*x, y*y];

for verticalIt = 1 : n
    triangleA = firstColumnTriangleA;
    triangleB = firstColumnTriangleB;
    triangleC = firstColumnTriangleC;
    
    
    for horizontalIt = 1 : (n-verticalIt)
        % I quadrant
        calculateInQuadrant(triangleA, triangleB, triangleC, vectorsIt);
        % II quadrant
        calculateInQuadrant([-triangleA(1), triangleA(2)], [-triangleB(1), triangleB(2)], [-triangleC(1), triangleC(2)], vectorsIt + nSquared);
        % III 
        calculateInQuadrant([-triangleA(1), -triangleA(2)], [-triangleB(1), -triangleB(2)], [-triangleC(1), -triangleC(2)], vectorsIt + 2*nSquared);
        % IV quadrant
        calculateInQuadrant([triangleA(1), -triangleA(2)], [triangleB(1), -triangleB(2)], [triangleC(1), -triangleC(2)], vectorsIt + 3*nSquared);
        
        vectorsIt = vectorsIt + 1;
        
        % Reflection of current triangle by adding 'inverseN' to right angle vertice
        triangleA_Ref = triangleA + [nInverse, nInverse];
        calculateInQuadrant(triangleA_Ref, triangleB, triangleC, vectorsIt);
        calculateInQuadrant([-triangleA_Ref(1), triangleA_Ref(2)], [-triangleB(1), triangleB(2)], [-triangleC(1), triangleC(2)], vectorsIt + nSquared);
        calculateInQuadrant([-triangleA_Ref(1), -triangleA_Ref(2)], [-triangleB(1), -triangleB(2)], [-triangleC(1), -triangleC(2)], vectorsIt + 2*nSquared);
        calculateInQuadrant([triangleA_Ref(1), -triangleA_Ref(2)], [triangleB(1), -triangleB(2)], [triangleC(1), -triangleC(2)], vectorsIt + 3*nSquared);
        
        vectorsIt = vectorsIt + 1;
        
        triangleA(1) = triangleA(1) + nInverse;
        triangleB(1) = triangleB(1) + nInverse;
        triangleC(1) = triangleC(1) + nInverse;
    end
   
    % Last triangle in row does not have reflection
    calculateInQuadrant(triangleA, triangleB, triangleC, vectorsIt);
    calculateInQuadrant([-triangleA(1), triangleA(2)], [-triangleB(1), triangleB(2)], [-triangleC(1), triangleC(2)], vectorsIt + nSquared);
    calculateInQuadrant([-triangleA(1), -triangleA(2)], [-triangleB(1), -triangleB(2)], [-triangleC(1), -triangleC(2)], vectorsIt + 2*nSquared);
    calculateInQuadrant([triangleA(1), -triangleA(2)], [triangleB(1), -triangleB(2)], [triangleC(1), -triangleC(2)], vectorsIt + 3*nSquared);
    
    vectorsIt = vectorsIt + 1;
   
    % We are going to next row
    firstColumnTriangleA(2) = firstColumnTriangleA(2) + nInverse;
    firstColumnTriangleB(2) = firstColumnTriangleB(2) + nInverse;
    firstColumnTriangleC(2) = firstColumnTriangleC(2) + nInverse;
end

% Calculating center of mass, triangle points, interpolation polynomial values, and 'func' values
function calculateInQuadrant(triangleA, triangleB, triangleC, vectorsIt)
        xCoordinates(vectorsIt) = (triangleA(1) + triangleB(1) + triangleC(1)) / 3;
        yCoordinates(vectorsIt) = (triangleA(2) + triangleB(2) + triangleC(2)) / 3;
       
        trianglePoints = [triangleA(1), triangleA(2);
                          triangleB(1), triangleB(2);
                          triangleC(1), triangleC(2);
                          (triangleA(1) + triangleB(1)) / 2, (triangleA(2) + triangleB(2)) / 2;
                          (triangleA(1) + triangleC(1)) / 2, (triangleA(2) + triangleC(2)) / 2;
                          (triangleB(1) + triangleC(1)) / 2, (triangleB(2) + triangleC(2)) / 2];
                      
        % Interpolating polynomial coefficients
        equations = zeros(6);
        values = zeros(6, 1);
        for i = 1:6
            equations(i, :) = polynomialScheme(trianglePoints(i, 1), trianglePoints(i, 2));
            values(i) = func(trianglePoints(i, 1), trianglePoints(i, 2));
        end
        
        a = (equations \ values)';
        interpolatingPolynomial = @(x, y) (a(1) + a(2)*x + a(3)*y + a(4)*x*y + a(5)*x*x + a(6)*y*y);
        
        interpolatingPolynomialValues(vectorsIt) = interpolatingPolynomial(xCoordinates(vectorsIt), yCoordinates(vectorsIt));
        funcValues(vectorsIt) = func(xCoordinates(vectorsIt), yCoordinates(vectorsIt));
end


meanSquaredError = sum((interpolatingPolynomialValues - funcValues).^2) / (4*nSquared);
valuesArray = [(1:4*n^2)' xCoordinates', yCoordinates', interpolatingPolynomialValues', funcValues',... 
               (abs(interpolatingPolynomialValues - funcValues) ./ abs(funcValues+eps) * 100)'];
end