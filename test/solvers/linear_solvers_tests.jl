
A = [[+4.  +5.  -2.]
     [+7.  -1.  +2.]
     [+3.  +1.  +4.]]
b = [-14., +42., +28.]
x = [+4., -4., +5.]

lu = LUSolverLAPACK(A, b)

factorize!(lu)
solve!(lu)

@test lu.b == x
