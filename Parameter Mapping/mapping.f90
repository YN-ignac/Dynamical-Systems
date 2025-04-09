program mapping
!------------------------------------------------------------------------------------
! Program for mapping of CSTR1EXO model
    implicit none

    ! Declarations
    real(8) :: theta_min, theta_max
    integer :: steps
    real(8) :: gama, B, lambda, thetaC, beta
    COMMON /pars/ gama, B, lambda, thetaC, beta
    integer :: i
    real(8) :: theta, X, Da
    real(8) :: J
    dimension J (1:2, 1:2)
    real(8) :: lambda1, lambda2
    dimension lambda1(1:2), lambda2(1:2)
!------------------------------------------------------------------------------------
    ! Open files for input and output
    OPEN(10,file='input.txt')
    OPEN(11,file='output.txt')
    OPEN(12,file='output_stable.txt')
    OPEN(13,file='output_unstable.txt')

    ! Read parameters from input file
    READ(10,*) theta_min, theta_max, steps
    READ(10,*) gama, B, lambda, thetaC, beta

    theta = theta_min ! Initialize theta to the minimum value

    ! Calculate the mapping for each value of theta
    do i = 1, steps
        ! Call the mapping function
        ! Call the jacobi function to calculate the Jacobian matrix
        ! Call the eigen function to calculate the eigenvalues
        call map(theta, X, Da)
        call jacobi(theta, X, Da, J)
        call eigen(J, lambda1, lambda2)

        ! Print the results to the output file
        WRITE(11,*) X, theta, Da, lambda1(1), lambda1(2), lambda2(1), lambda2(2)

        ! Check the eigenvalues and write to the appropriate file
        ! If both eigenvalues are negative, write to stable file else to unstable file
        ! The eigenvalues are stored in lambda1 and lambda2 arrays
        ! The first element of each array is the real part and the second is the imaginary part
        ! The condition checks if both eigenvalues are negative
        if (lambda1(1) .lt. 0 .and. lambda2(1) .lt. 0) then
        WRITE(12,*) X, theta, Da
        else
        WRITE(13,*) X, theta, Da
        end if

        ! Print the results to the console
        WRITE(*,*) "i   X   theta   Re1     Im1     Re2     Im2"
        WRITE(*,*) "----------------------------------------------------"
        WRITE(*,*) i, X, theta, Da, lambda1(1), lambda1(2), lambda2(1), lambda2(2)
        
        theta = theta + (theta_max - theta_min) / steps ! Increment theta 
    end do
        
    ! Close files
    CLOSE(10)
    CLOSE(11)
    CLOSE(12)
    CLOSE(13)

end program mapping
!------------------------------------------------------------------------------------

! Subroutines for mapping, jacobian and eigenvalue calculation

!------------------------------------------------------------------------------------

! Subroutine for mapping
subroutine map(theta, X, Da)
    
    implicit none

    ! Declarations
    real(8) :: theta, X, Da
    real(8) :: gama, B, lambda, thetaC, beta
    COMMON /pars/ gama, B, lambda, thetaC, beta

    ! Calculate the mapping using the given equations
    ! The equations are derived from the CSTR1EXO model
    X = theta/B + beta*(theta - thetaC)/(B*lambda)
    Da = lambda*X/(1-X)/exp(theta/(1+theta/gama))

end subroutine map

!------------------------------------------------------------------------------------

! Subroutine for calculating the Jacobian matrix
subroutine jacobi(theta, X, Da, J)
    
    implicit none

    ! Declarations
    real(8) :: theta, X, Da
    real(8) :: gama, B, lambda, thetaC, beta
    COMMON /pars/ gama, B, lambda, thetaC, beta
    real(8) :: J, exponent
    dimension J (1:2, 1:2)

    exponent = exp(theta/1+theta/gama) ! Calculate the exponent term

    ! Calculate the Jacobian matrix using the given equations (derived from the CSTR1EXO model)
    ! The Jacobian matrix is a 2x2 matrix with the following elements:
    J(1,1) = -lambda-Da*exponent
    J(1,2) = Da*(1-X) * exponent * (1+theta/gama-theta/gama)/(1+theta/gama)**2
    J(2,1) = -Da*B*exponent
    J(2,2) = -lambda + B * Da * (1-X) * exponent * (1+theta/gama-theta/gama)/(1+theta/gama)**2 - beta
  
end subroutine jacobi

!------------------------------------------------------------------------------------

! Subroutine for calculating the eigenvalues of the Jacobian matrix
! The eigenvalues are calculated using the characteristic polynomial of the matrix
subroutine eigen(J, lambda1, lambda2)
    
    implicit none

    ! Declarations
    real(8) :: J
    dimension J (1:2, 1:2)
    real(8) :: lambda1, lambda2
    dimension lambda1(1:2), lambda2(1:2)
    real(8) :: tr_J, det_J, disc

    ! Calculate the trace and determinant of the Jacobian matrix
    ! The trace is the sum of the diagonal elements and the determinant is calculated using the formula
    tr_J = J(1,1) + J(2,2)
    det_J = J(1,1)*J(2,2) - J(1,2)*J(2,1)

    ! Calculate the discriminant of the characteristic polynomial
    ! The discriminant is used to determine the nature of the eigenvalues
    disc = tr_J**2 - 4 * det_J

    ! Calculate the eigenvalues based on the discriminant
    ! If the discriminant is positive, the eigenvalues are real and distinct
    ! If the discriminant is zero, the eigenvalues are real and equal
    ! If the discriminant is negative, the eigenvalues are complex conjugates
    if (disc .ge. 0.0) then
        lambda1(1) = (tr_J + disc**0.5) / 2.0
        lambda1(2) = 0.0
        lambda2(1) = (tr_J - disc**0.5) / 2.0
        lambda2(2) = 0.0
    else
        lambda1(1) = tr_J / 2
        lambda1(2) = abs(disc)**0.5 / 2.0
        lambda2(1) = tr_J / 2
        lambda2(2) = -abs(disc)**0.5 / 2.
    end if    
  
end subroutine eigen

!------------------------------------------------------------------------------------