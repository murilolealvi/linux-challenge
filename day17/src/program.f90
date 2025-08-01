USE module_lib
IMPLICIT NONE

REAL:: sum_result
REAL::a=1, b=2

sum_result = sumall(a,b)

WRITE(*,*) "Sum result is: ", sum_result

END PROGRAM

