MODULE module_lib

    IMPLICIT NONE
    CONTAINS
        FUNCTION sumall(a,b)
            REAL, INTENT(IN):: a
            REAL, INTENT(IN):: b
            REAL:: sumall

            sumall = a+b
        END FUNCTION
    END MODULE