!-------------------------------------------------------------------
! Continuation method for solving nonlinear systems of equations
! This program uses a predictor-corrector method to find the solution of a system of nonlinear equations.
! The system is defined by the function RHS and its Jacobian matrix J.
! The program uses Newton's method for the corrector step and an Euler method for the predictor step.
! The program reads input parameters from a file and writes the output to another file.
! The program also includes adaptive step size control for the Euler method.
!-------------------------------------------------------------------
program continuation
!-------------------------------------------------------------------
    implicit none
!--------------------------------------------------------------------
    
    ! Declaration 
    integer :: nmax
    parameter (nmax=10) ! maximal dimension of y
    integer :: ndim, i
    real(8) :: f, J
    dimension f(1:nmax), J(1:nmax, 1:nmax+1)
    real(8) :: y
    dimension y(1:nmax+1) ! pre-made array of size 1:nmax+1
    real(8) :: delta, tanv, tanvold, skals
    dimension delta(1:nmax+1), tanv(1:nmax+1), tanvold(1:nmax+1)
    integer :: kfix, ierr
    integer :: inewt, maxnewt, ieul, maxeul
    real(8) :: norm, eps, step, minstep, maxstep

    real(8) :: gama, B, lambda, thetaC, beta
    COMMON /pars/ gama, B, lambda, thetaC, beta 

    ! Load data & assign data
    OPEN(10, file ='input.txt')
    OPEN(11, file='output.txt')

    READ(10,*) ndim, (y(i), i=1,ndim+1)
    READ(10,*) gama, B, lambda, thetaC, beta
    READ(10,*) maxnewt, eps
    READ(10,*) maxeul
    READ(10,*) step, minstep, maxstep

    ! Initialize tangent vector
    do i=1,ndim+1
        tanvold(i) = 0.00
    end do
    tanvold(3) = 1.0

    !! PREDICTOR - CORRECTOR METHOD
    ! Euler cycle
    do ieul = 1, maxeul
        ! Newton cycle
        do inewt = 1,maxnewt
            WRITE(*,*) 'Newton iteration no.', inewt

            ! Create right hand sides
            call RHS(ndim, nmax, y, f, J)
            WRITE(*,*) 'y= ', (y(i), i=1,ndim+1) 
            WRITE(*,*) 'f= ', (f(i), i=1,ndim)
            WRITE(*,*) 'J= ', (j(1,i), i=1,ndim+1)
            WRITE(*,*) '   ', (j(2,i), i=1,ndim+1)

            ! Call gauss elimination to solve the eq.
            call gauss(ndim, ndim+1, nmax, J, f, delta, tanv, kfix, ierr)
            WRITE(*,*) 'delta= ', (delta(i), i=1,ndim+1)
            
            ! Corections
            do i=1,ndim+1
                y(i) = y(i) - delta(i)
            end do
            WRITE(*,*) 'y= ', (y(i), i=1,ndim+1)
            
            ! Check convergence
            ! Calculate norm of delta
            norm = 0.0
            do i=1,ndim+1
                norm = norm + delta(i)**2
            end do
            norm = norm**0.5
            WRITE(*,*) 'norm =', norm
            
            ! Check if the norm is less than the tolerance
            if (norm .le. eps) then
                WRITE(*,*) 'Newton OK'
                exit
            else
                WRITE (*,*) 'Newton did not converge!'
            end if
        end do

        write(11,*) (y(i),i=1,ndim+1) ! Write the solution to the output file

        ! Adaptive step
        if (inewt .eq. 1) step = 2.0*step
        if (inewt .eq. 2) step = 1.5*step
        if (inewt .eq. 4) step = 0.8*step
        if (inewt .ge. 5) step = 0.5*step
        if (step .le. minstep) step = minstep
        if (step .ge. maxstep) step = maxstep
        write(*,*)'Newton step =', step

        ! Create right hand sides
        call RHS(ndim, nmax, y, f, J)
        WRITE(*,*) 'y= ', (y(i), i=1,ndim+1) 
        WRITE(*,*) 'f= ', (f(i), i=1,ndim)
        WRITE(*,*) 'J= ', (j(1,i), i=1,ndim+1)
        WRITE(*,*) '   ', (j(2,i), i=1,ndim+1)

        WRITE(*,*) 'Euler step no.', ieul
        
        ! Call gauss elimination to solve the eq.
        call gauss(ndim, ndim+1, nmax, J, f, delta, tanv, kfix, ierr)
        WRITE(*,*) 'tanv= ', (tanv(i),i=1,ndim+1)

        ! Calculate the norm of the tangent vector
        skals=0.0
        do i=1,ndim+1
            skals=skals + tanv(i) * tanvold(i)
        end do
        WRITE(*,*) 'skals= ', skals

        if (skals .lt. 0.0) then
            WRITE(*,*) 'Reverse direction'
            ! Reverse the direction of the tangent vector
            do i=1,ndim+1
                tanv(i) = -tanv(i)
            end do
        end if

        ! Step correction
        do i = 1, ndim+1
            y(i) = y(i) + tanv(i)*step
            tanvold(i) = tanv(i)
        end do
        WRITE(*,*) 'y= ', (y(i),i=1,ndim+1)
    end do

    WRITE(*,*) 'End of the program'
    READ(*,*)
    
    CLOSE(10)
    CLOSE(11)

end program continuation

!-------------------------------------------------------------------
! Subroutine to calculate the right-hand side of the system of equations
!-------------------------------------------------------------------
subroutine RHS(ndim, nmax, y, f, J)
!-------------------------------------------------------------------
    implicit none
!--------------------------------------------------------------------
    ! Declaration
    integer :: ndim, nmax
    real(8) :: y, f, J
    dimension y(1:nmax+1), f(1:nmax), J(1:nmax, 1:nmax+1)
    real(8) :: x, theta, Da, exponent

    real(8) :: gama, B, lambda, thetaC, beta
    COMMON /pars/ gama, B, lambda, thetaC, beta 

    ! Assign values from y to variables
    x = y(1)
    theta = y(2)
    Da = y(3)

    exponent = exp(theta/1+theta/gama) !! Calculate the exponent term

    ! Calculate the right-hand side of the system of equations
    f(1) = -lambda*x + Da*(1-x)*exponent
    f(2) = -lambda*theta + Da*B*(1-x)*exponent - beta*(theta-thetaC)

    ! Calculate the Jacobian matrix
    J(1,1) = -lambda-Da*exponent
    J(1,2) = Da*(1-X) * exponent * (1+theta/gama-theta/gama)/(1+theta/gama)**2
    J(1,3) = (1-x)*exponent

    J(2,1) = -Da*B*exponent
    J(2,2) = -lambda + B * Da * (1-X) * exponent * (1+theta/gama-theta/gama)/(1+theta/gama)**2 - beta
    J(2,3) = B*(1-x)*exponent
  
end subroutine RHS
!-------------------------------------------------------------------