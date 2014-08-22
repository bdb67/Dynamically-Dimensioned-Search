I wrote an R implementation of Tolson & Shoemaker's DDS algorithm.  Questions relating to my implementation of the algorithm can be directed to admin@brandon-d-bass.com.  All usage and licensing questions should be directed to Dr. Bryan Tolson at btolson@uwaterloo.ca.  

Dynamically-Dimensioned-Search
==============================

Tolson &amp; Shoemaker's DDS Algorithm implementation in R 

REFERENCE FOR THIS ALGORITHM:
Tolson, B. A., and C. A. Shoemaker (2007), Dynamically dimensioned search algorithm for computationally efficient watershed model calibration, Water Resour. Res., 43, W01413, doi:10.1029/2005WR004723.
DDS is an n-dimensional, heuristic, probabilistic global optimization algorithm for continuous, box-constrained (bound-constrained) optimization problems. DDS is designed to find good solutions quickly and requires little if any algorithm parameter tuning.

WHO SHOULD TRY DDS?
------------------
- those who have a highly dimensional (6 or more decision variables) continuous global optimization problem (multiple local optima). I have found good DDS performance relative to other global optimization methods for many 6-30 dimensional (# of decision variables) optimization problems as well as up to a 300 dimensional problem.
- especially those who meet the criterion above AND are optimizing a computationally expensive objective function such as a spatially distributed environmental simulation model calibration problem (e.g. watershed model). In my research, DDS has generated excellent watershed model calibration results in as few as 200 model evaluations for a 14 dimensional problem (14 model parameters were calibrated).
- DDS was *not* developed for (and thus performance *not* tested relative to other algorithms) optimizing low-dimensional problems (5 or fewer decision variables). Currently, algorithm modifications are being tested to determine relative DDS performance on these lower dimensional problems.
- for convex optimization problems, derivative-based optimization algorithms are expected to be more effective and efficient than DDS (especially low to moderate dimensions)

GENERAL DDS ALGORITHM DESCRIPTION:
---------------------------------
---------------------------------
- an intentionally incomplete description of the algorithm is given as follows 
- The DDS algorithm is a novel and simple stochastic single-solution based heuristic global search algorithm that was developed for the purpose of finding good global solutions (as opposed to globally optimal solutions) within a specified maximum objective function (or model) evaluation limit.
- The only algorithm parameter to set in the DDS algorithm is the scalar neighborhood size perturbation parameter (r_val). A default value of the r_val parameter is recommended as 0.2 because this yields a sampling range that practically spans the normalized decision variable range. Empirical testing also showed this value to be robust and enables the algorithm to easily escape regions around poor local minima.
- The algorithm is designed to scale the search to the user-specified number of maximum objective function evaluations and thus has no other stopping criteria.
- The maximum number of function evaluations (m) is an algorithm input (like the initial solution) rather than algorithm parameter because it should be set according to the problem specific available (or desired) computational time the user wishes to spend solving the optimization problem. The value of m therefore depends on the time to compute the objective function on the available computational resources. Except for the most computationally trivial objective functions, essentially 100% of DDS execution time is associated with objective function evaluations.
- It must be clarified that the DDS algorithm is not designed to converge to the precise global optimum. Instead, it is designed to converge to the region of the global optimum in the best case or the region of a good local optimum in the worst case.
- DDS has at least three advantages relative to most population-based, evolutionary algorithms (e.g. GA, SCE, PSO etc.):
a) It has an immediate efficiency advantage because it is not population-based
b) It is designed to find good solutions quickly and thus it adjusts to the user-specified computational scale to generate good solutions without requiring any algorithm parameter adjustment.
c) It has only one algorithm parameter (r_val) that is easily interpreted and has a reasonably well established default value that has been shown to produce good results over a range of test problems. For most problems, I have found that the default of 0.2 will produce good answers and thus no algorithm parameter fine-tuning is recommended (unless of course ample computational resources make this feasible – try 0.1).
