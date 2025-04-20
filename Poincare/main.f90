!! This program simulates the Lorenz system using the Euler method. 
!---------------------------------------------------------------------------------------------------------
program lorenz_model
!---------------------------------------------------------------------------------------------------------
    implicit none
!---------------------------------------------------------------------------------------------------------
    ! Declarations
    integer :: ndim, i, j, nsteps
    integer, parameter :: nmax = 100

    real(8) :: y, f, S, gradS, scals, yp
    dimension :: y(1:nmax), f(1:nmax), gradS(1:nmax), yp(1:nmax)

    real(8) :: y_old, S_old
    dimension :: y_old(1:nmax)

    real(8) :: sigma, b, r
    common /pars/ sigma, b, r
    real(8) :: step

    ! Open/Read necessary files
    Open(10, file='input.txt')
    Open(11, file='output.txt')
    Open(12, file='intersections.txt')

    Read(10,*) ndim, (y(i), i=1,ndim)
    Read(10,*) sigma, b, r
    Read(10,*) step, nsteps
!---------------------------------------------------------------------------------------------------------    
    ! Loop over "time" steps
    do j = 1,nsteps

    ! Call RHS subroutine
    call rhs(ndim, nmax, y, f)

    ! Call Poincare subroutine
    Write(*,*) 'Step (old. val.)', j-1, ':', (y(i), i=1,ndim), 'Poincare section:', S
    call poincare(ndim, nmax, y, f, S, gradS)

    ! Check if the Poincare section has crossed the plane
    if (S_old .gt. 0.0 .and. S .lt. 0.0) then

        Write(*,*) 'Crossed the plane!'

        scals = 0.0
        do i=1,ndim
            scals = scals + f(i) * gradS(i)
        end do

        do i=1,ndim
            yp(i) = y(i) - S * gradS(i) / scals
        end do

        Write(*,*) 'Intersection point:', (yp(i), i=1,ndim)
        Write(12,*) (yp(i), i=1,ndim)

        !Read(*,*) ! Wait for user input to continue

    end if

    ! Store old values for comparison
    S_old = S

    do i=1,ndim
        y_old(i) = y(i)
    end do

    ! Update y using the Euler method
    ! One step of the Euler method
        do i=1,ndim
            y(i) = y(i) + f(i) * step
        end do
        
        ! Print results to screen and file
        Write(*,*) 'Step (new val.)', j, ':', (y(i), i=1,ndim), 'Poincare section:', S
        Write(11,*) j, (y(i), i=1,ndim)
      
    end do

    ! Close files
    Close(10)
    Close(11)
    Close(12)

end program lorenz_model

subroutine rhs(ndim, nmax, y, f)
    implicit none
    integer :: ndim, nmax
    real(8) :: y(1:nmax), f(1:nmax)
    real(8) :: sigma, b, r
    common /pars/ sigma, b, r

    ! Lorenz equations
    f(1) = sigma * (y(2) - y(1))
    f(2) = -y(1) * y(3) + r * y(1) - y(2)
    f(3) = y(1) * y(2) - b * y(3)

    return
end subroutine rhs

subroutine poincare(ndim, nmax, y, f, S, gradS)
    implicit none
    integer :: ndim, nmax
    real(8) :: y(1:nmax), f(1:nmax), S, gradS(1:nmax)
    real(8) :: sigma, b, r
    common /pars/ sigma, b, r

    !S = y(3) - 35.0

    !gradS(1) = 0.0
    !gradS(2) = 0.0
    !gradS(3) = 0.1

    S = f(2)

    gradS(1) = -y(3) + r
    gradS(2) = -1.0
    gradS(3) = y(1)

    return
end subroutine poincare