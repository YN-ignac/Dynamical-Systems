!! This program simulates the Lorenz system using the Euler method. 
!---------------------------------------------------------------------------------------------------------
program lorenz_model
!---------------------------------------------------------------------------------------------------------
    implicit none
!---------------------------------------------------------------------------------------------------------
    ! Declarations
    integer :: ndim, i, j, nsteps
    integer, parameter :: nmax = 100
    real(8) :: y, f
    dimension :: y(1:nmax), f(1:nmax)
    real(8) :: sigma, b, r
    common /pars/ sigma, b, r
    real(8) :: step

    ! Open/Read necessary files
    Open(10, file='input.txt')
    Open(11, file='output.txt')

    Read(10,*) ndim, (y(i), i=1,ndim)
    Read(10,*) sigma, b, r
    Read(10,*) step, nsteps
!---------------------------------------------------------------------------------------------------------    
    ! Loop over "time" steps
    do j = 1,nsteps

    ! Call RHS subroutine
        call rhs(ndim, nmax, y, f)

    ! One step of the Euler method
        do i=1,ndim
            y(i) = y(i) + f(i) * step
        end do
        
        ! Print results to screen and file
        !Write(*,*) 'Step', j, ':', (y(i), i=1,ndim)
        Write(11,*) j, (y(i), i=1,ndim)

    end do

    ! Close files
    Close(10)
    Close(11)

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

end subroutine rhs