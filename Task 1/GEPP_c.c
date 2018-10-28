/*
 * GEPP.c - example in MATLAB External Interfaces
 *
 * Solves linear system of equations
 * where A ist NxN matrix, b is 1xN, horizontal vector,
 * and output is 1xN, horizontal vector x
 *
 * The calling syntax is:
 *
 *		x = GEPP(A, b)
 *
 * This is a MEX file for MATLAB.
*/
#include <stdlib.h>
#include <math.h>
#include "mex.h"

void Calculate(double *A, const double *b, double *x, unsigned n)
{
#define eps 1e-12
#define A(i, j) A[i * n + j]

    memcpy(x, b, n*sizeof(double));

    for (unsigned i = 0; i < n; ++i)
    {
        //finding max here
        unsigned maxIndex = i;
        for (unsigned r = i + 1; r < n; ++r)
        {
            if (fabs(A(r, i)) > fabs(A(maxIndex, i)))
            {
                maxIndex = r;
            }
        }

        //swaping rows here
        if (maxIndex != i)
        {
            double temp;
            for (unsigned c = i; c < n; ++c)
            {
                temp = A(i, c);
                A(i, c) = A(maxIndex, c);
                A(maxIndex, c) = temp;
            }

            temp = x[i];
            x[i] = x[maxIndex];
            x[maxIndex] = temp;
        }

        if(fabs(A(i, i)) < eps)
        {
            mexErrMsgIdAndTxt("GEPP:determinant", "Wyznacznik macierzy jest zerowy.");
        }

        //substracting our current 'max' row from the others
        unsigned row = i*n;
        for(unsigned r = 0; r < n; ++r)
        {
            if(r == i)
            {
                continue;
            }

            double mult = A(r, i) / A[row + i];
            unsigned rowr = r*n;
            for(unsigned c = i; c < n; ++c)
            {
                A[rowr + c] -= mult * A[row + c];
            }

            x[r] -= mult * x[i];
        }       
    }

    //getting result
    for(unsigned i = 0; i < n; ++i)
    {
        x[i] /= A(i, i);
    }
}

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
    if (nrhs != 2)
    {
        mexErrMsgIdAndTxt("GEPP:input", "Wymagane 2 argumenty.");
    }

    if (nlhs != 1)
    {
        mexErrMsgIdAndTxt("GEPP:output", "Wymagany 1 argument wyjsciowy.");
    }

    if (mxGetN(prhs[0]) != mxGetN(prhs[1]))
    {
        mexErrMsgIdAndTxt("GEPP:vectorMatrixDifferentSize", "Macierz A i wektor b musza miec ten sam rozmiar.");
    }

    if (mxGetM(prhs[1]) != 1)
    {
        mexErrMsgIdAndTxt("GEPP:notRowVector", "Wejsciowy wektor b musi byc wektorem poziomym.");
    }

    double *A;
    double *b;
    double *x;
    unsigned n;

    A = mxGetDoubles(prhs[0]);
    b = mxGetDoubles(prhs[1]);
    n = mxGetN(prhs[1]);

    plhs[0] = mxCreateDoubleMatrix(1, n, mxREAL);
    x = mxGetDoubles(plhs[0]);

    Calculate(A, b, x, n);
}
