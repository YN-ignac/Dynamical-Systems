
! Continuation - Limit Points (LP)

!------------------------------------------------------------------------
    ! This program is a continuation method for finding limit points of a system of equations.
    ! It uses a predictor-corrector method with Newton's method for solving the equations.
    ! The program reads input data from a file, performs calculations, and writes the results to an output file.
    ! The equations are defined in the subroutine RHS, and the Jacobian matrix is computed in the same subroutine.
    ! The program also includes a subroutine for finite difference approximation of the Jacobian matrix.
    ! The main program iterates through the predictor-corrector method, updating the solution and step size adaptively.
!------------------------------------------------------------------------
program kontinuace
!---------------------------------------------------------------------
    implicit none
!---------------------------------------------------------------------

    ! Declaration 
    integer :: nmax
    parameter (nmax=10) ! maximal dimension of y

    real(8) :: gama, B, lambda, thetaC
    COMMON /pars/ gama, B, lambda, thetaC

    integer :: ndim, i
    real(8) :: y, f, J
    dimension y(1:nmax+1), f(1:nmax), J(1:nmax,1:nmax+1)
    
    real(8) :: delta, tanv, tanvold
    dimension delta(1:nmax+1), tanv(1:nmax+1), tanvold(1:nmax+1)

    integer :: kfix, ierr
    integer :: inewt, maxnewt, ieul, maxeul
    real(8) :: norm, eps, step, minstep, maxstep, skals

    ! Load data & assign data
    OPEN(10, file ='input.txt')
    OPEN(11, file='output.txt')

    READ(10,*) ndim, (y(i), i=1,ndim+2)
    READ(10,*) gama, B, lambda, thetaC
    READ(10,*) maxnewt, eps
    READ(10,*) maxeul
    READ(10,*) step, minstep, maxstep

    ! Tangent vector
    do i=1,ndim+2
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
            call lp(ndim, nmax, y, f, J, eps)

            WRITE(*,*) 'y= ', (y(i), i=1,ndim+2) 
            WRITE(*,*) 'f= ', (f(i), i=1,ndim+1)
            WRITE(*,*) 'J= ', (j(1,i), i=1,ndim+2)
            WRITE(*,*) '   ', (j(2,i), i=1,ndim+2)
            WRITE(*,*) '   ', (j(3,i), i=1,ndim+2)

            ! Call gauss elimination to solve the eq.
            call gauss(ndim+1, ndim+2, nmax, J, f, delta, tanv, kfix, ierr)
            WRITE(*,*) 'delta= ', (delta(i), i=1,ndim+2)
            
            ! Corections
            do i=1,ndim+2
                y(i) = y(i) - delta(i)
            end do
            WRITE(*,*) 'y= ', (y(i), i=1,ndim+2)
            
            norm = 0.0
            do i=1,ndim+2
                norm = norm + delta(i)**2
            end do
            norm = norm**0.5
            WRITE(*,*) 'norm =', norm

            if (norm .le. eps) then
                WRITE(*,*) 'Newton OK'
                exit
            else
                WRITE (*,*) 'Newton did not converge!'
            end if
        end do

        write(11,*) (y(i), i=1, ndim+2)

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
        call lp(ndim, nmax, y, f, J, eps)

        WRITE(*,*) 'y= ', (y(i), i=1,ndim+2) 
        WRITE(*,*) 'f= ', (f(i), i=1,ndim+1)
        WRITE(*,*) 'J= ', (j(1,i), i=1,ndim+2)
        WRITE(*,*) '   ', (j(2,i), i=1,ndim+2)
        WRITE(*,*) '   ', (j(3,i), i=1,ndim+2)

        WRITE(*,*) 'Euler step no.', ieul
        
        ! Call gauss elimination to solve the eq.
        call gauss(ndim+1, ndim+2, nmax, J, f, delta, tanv, kfix, ierr)
        WRITE(*,*) 'tanv= ', (tanv(i),i=1,ndim+2)

        skals=0.0
        do i=1,ndim+2
            skals = skals + tanv(i) * tanvold(i)
        end do
        WRITE(*,*)'skals=',skals

        if (skals .lt. 0.0) then
            WRITE(*,*)'otacim smer'
            do i=1,ndim+2
                tanv(i)=-tanv(i)
            end do
        end if

        ! Step correction
        do i = 1, ndim+2
            y(i) = y(i) + tanv(i)*step
            tanvold(i) = tanv(i)
        end do
        WRITE(*,*) 'y= ', (y(i),i=1,ndim+2)
    end do

    CLOSE(10)
    CLOSE(11)

end program kontinuace

subroutine RHS(ndim, nmax, y, f, J)

    implicit none

    integer :: ndim, nmax
    real(8) :: y, f, J, det
    dimension y(1:nmax+1), f(1:nmax), J(1:nmax, 1:nmax+1)
    real(8) :: x, theta, Da, exponent

    real(8) :: gama, B, lambda, thetaC, beta
    COMMON /pars/ gama, B, lambda, thetaC

    x = y(1)
    theta = y(2)
    Da = y(3)
    beta = y(4)

    exponent = exp(theta/1+theta/gama)

    f(1) = -Lambda*x + Da*(1-x)*exponent
    f(2) = -Lambda*theta + Da*B*(1-x)*exponent - beta*(theta-thetaC)

    j(1,1) = -Lambda - Da*exponent
    j(1,2) = Da*(1-x)*exponent*(1+theta/gama-theta/gama)/(1+theta/gama)**2
    j(1,3) = (1-x)*exponent
    j(1,4) = 0.0

    j(2,1) = -Da*B*exponent
    j(2,2) = -Lambda + B*Da*(1-x)*exponent*(1+theta/gama-theta/gama)/(1+theta/gama)**2 -beta
    j(2,3) = B*(1-x)*exponent
    j(2,4) = -(theta-thetaC)

    det = j(1,1)*j(2,2)-j(1,2)*j(2,1)
    f(3) = det

    return
end subroutine RHS

subroutine lp(ndim, nmax, y, f, J, eps)

    implicit none

    integer :: ndim, nmax, i
    real(8) :: y, f, J, eps
    dimension y(1:nmax+1), f(1:nmax), J(1:nmax, 1:nmax+1)
    real(8) :: f2, J2
    dimension f2(1:nmax), J2(1:nmax, 1:nmax+1)

    do i = 1,ndim+2
        y(i) = y(i) + eps
        call RHS(ndim, nmax, y, f2, J2)
        j(3,i)=(f2(3)-f(3))/eps
        y(i)=y(i)-eps
    end do

    return
end subroutine lp