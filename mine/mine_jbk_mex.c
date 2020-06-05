/*  
    This code is written by Davide Albanese <davide.albanese@gmail.com>.
    (C) 2012 Fondazione Bruno Kessler, (C) 2012 Davide Albanese.

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

#include "mex.h"
#include "mine_jbk.h" /* Direct to JBK header file */


/* The gateway function
 * [MIC, MAS, MEV, MCN, MCN_GENERAL] = MINE_MEX(X, Y, ALPHA, C)
 */
void mexFunction(int nlhs, mxArray *plhs[],
		 int nrhs, const mxArray *prhs[])
{
  double *x, *y;
  double alpha;
  int c;
  
  mwSize ncolsx, ncolsy;
  
  mine_problem problem;
  mine_parameter param;
  mine_score *score;
  char *ret;
  double *out;

  
  /* check for proper number of outputs */
  if(nlhs != 1)
    mexErrMsgTxt("One output required.");

  /* check for proper number of arguments */
  if(nrhs != 4)
    mexErrMsgTxt("Incorrect number of inputs.");
   
  /* check that number of rows in first input argument (x) is 1 */
  if(mxGetM(prhs[0]) != 1)
    mexErrMsgTxt("X must be a row vector.");
  
  /* check that number of rows in second input argument (y) is 1 */
  if(mxGetM(prhs[1]) != 1)
    mexErrMsgTxt("Y must be a row vector.");
  
  /* make sure the thirth input argument (alpha) is scalar */
  if(!mxIsDouble(prhs[2]) || mxIsComplex(prhs[2]) ||
     mxGetNumberOfElements(prhs[2]) != 1) 
    mexErrMsgTxt("alpha must be a scalar.");
  
  /* make sure the fourth input argument (c) is scalar */
  if(!mxIsDouble(prhs[3]) || mxIsComplex(prhs[3]) ||
     mxGetNumberOfElements(prhs[3]) != 1) 
    mexErrMsgTxt("c must be a scalar.");
  
  /* get alpha and c */
  alpha = mxGetScalar(prhs[2]);
  c = mxGetScalar(prhs[3]);
  
  /* create a pointers for X and Y */
  x = mxGetPr(prhs[0]);
  y = mxGetPr(prhs[1]);
  ncolsx = mxGetN(prhs[0]);
  ncolsy = mxGetN(prhs[1]);

  /* check the number of elements of X and Y */
  if (ncolsx != ncolsy)
    mexErrMsgTxt("X and Y must have the same number of elements.");      
  
  /* build param */
  param.alpha = alpha;
  param.c = c;

  /* check param */
  ret = mine_check_parameter(&param);
  if(ret)
    mexErrMsgTxt(ret);
  
  /* build problem */
  problem.n = (int) ncolsx;
  problem.x = x;
  problem.y = y;
  
  /* compute the mutual information score */
  score = mine_compute_score(&problem, &param);
  if(score == NULL)
    mexErrMsgTxt("Problem with mine_compute_score().");

  /* build the output array*/
  plhs[0] = mxCreateDoubleMatrix(1,8, mxREAL); /* JBK added 1 output */
  out = mxGetPr(plhs[0]);
  out[0] = mine_mic(score);
  out[1] = mine_mas(score);
  out[2] = mine_mev(score);
  out[3] = mine_mcn(score, 0);
  out[4] = mine_mcn_general(score);
  out[5] = mine_mi(score); /* JBK THIS IS THE UNDERLYING MI!!! */
  out[6] = mine_xbins(score);
  out[7] = mine_ybins(score);

  mine_free_score(&score);
}
