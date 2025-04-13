program LotkaVolterra
  implicit none

    ! Declare variables
    integer, parameter :: neq = 2
    real(8), parameter :: tbeg = 0.0           ! Start of integration, s
    real(8), parameter :: tend = 100           ! End of integration, s
    real(8), parameter :: tstep = 1.0d-3       ! Time step 
    integer, parameter :: Nsteps = int((tend-tbeg)/tstep)+1 ! Nubmer of calls to LSODE

    real(8) :: yout(neq, Nsteps)          ! Matrix of integration output
    real(8) :: pars(4)                   ! Vector of model parameters

    common /parameters/ pars

    !--------------------------------------------------------------------------

    ! Initiate model parameters
    call model_pars(pars)

    ! Run model simulation
    call simulate_model(neq, Nsteps, tbeg, tend, tstep, yout)

    ! Output model results
    call model_output(neq,Nsteps,tstep,yout)


end program LotkaVolterra

!===========================================================================================================================

subroutine model_pars(pars)
    !--------------------------------------------------------------
    implicit none
    !--------------------------------------------------------------
    ! Declare and assign parameters
    real(8), parameter :: a = 2
    real(8), parameter :: b = 1
    real(8), parameter :: alpha = 1
    real(8), parameter :: beta = 0.8

    real(8) :: pars(4)

    pars(1) = a
    pars(2) = b
    pars(3) = alpha
    pars(4) = beta

    return
end subroutine model_pars

!===========================================================================================================================

subroutine model_eqs(neq, t, y, dydt)
    !--------------------------------------------------------------
    implicit none
    !--------------------------------------------------------------
    ! Input/Output arguments
    integer :: neq              ! Number of model equations 
    real(8) :: t                ! Time
    real(8) :: y(neq)           ! Vector of state variables 
    real(8) :: dydt(neq)        ! Vector of right-hand sides
    real(8) :: pars(4)          ! Vector of parameters

    real(8) :: prey, predator   ! Prey and predator populations
    real(8) :: a, b, alpha, beta  ! Parameters

    common /parameters/ pars
    
    ! State variables
    prey = y(1)  ! Prey population
    predator = y(2)  ! Predator population

    ! Parameters
    a = pars(1)  ! Growth rate of prey
    b = pars(2)  ! Death rate of predator
    alpha = pars(3)  ! Rate of predation
    beta = pars(4)  ! Growth rate of predator per prey eaten

    ! ---------------------------------------------------------------------
    ! Model equations
    ! ---------------------------------------------------------------------
    dydt(1) = a * prey - alpha * prey * predator
    dydt(2) = -b * predator + beta * prey * predator
    
    return
end subroutine model_eqs

!===========================================================================================================================

subroutine JAC (NEQ, T, Y, ML, MU, PD, NROWPD)
    !--------------------------------------------------------------
    implicit none
    ! Dummy subroutine
    ! Jacobian is evaluated internally by LSODE
    integer :: NEQ, ML, MU, NROWPD
    double precision  :: T, Y(*), PD(NROWPD,*)
    
    return
    end subroutine JAC
!===========================================================================================================================

 subroutine simulate_model(neq, Nsteps, tbeg, tend, tstep, yout)
    !--------------------------------------------------------------
    implicit none
    !--------------------------------------------------------------
    ! Declare variables
    integer :: neq                  ! Number of ODEs in macro-scale model
    integer :: Nsteps               ! Number of calls to LSODE
    real(8) :: tbeg                  ! Start of integration, s
    real(8) :: tend                 ! End of integration, s
    real(8) :: tstep                    ! Time step for results output (ODE), s
    
    real(8) :: pars(4)              ! Vector of model parameters
    real(8) :: y(neq)               ! Vector of state variables
    real(8) :: yout(neq, Nsteps)    ! Matrix of integration output

    ! LSODE workspace variables
    integer :: lrw                 ! Dimension of real work array
    integer :: liw                 ! Dimension of integer work array

    ! Initial values of state variables
    real(8) :: prey0
    real(8) :: predator0

    integer :: i, j                ! Loop variable

    ! ODEPACK variables/parameters
    integer :: itol, itask, istate, iopt, mf
    integer, allocatable :: iwork(:)
    double precision :: t, tout, rtol, atol
    double precision, allocatable :: rwork(:)

    ! Externals
    external model_eqs
    external jac

    common /parameters/ pars 

!----------------------------------------------------------------------------------
    ! Load model parameters
    call model_pars(pars)

    ! Apply initial conditions
    prey0     = 1.0 
    predator0 = 0.2
    y(1) = prey0
    y(2) = predator0

    yout(:, 1) = y(:)

    ! Set up LSODE
    t      = tbeg           ! Integration start, seconds
    tout   = (tbeg + tstep) ! Integration end, seconds
    itol   = 1              ! ATOL is a scalar
    rtol   = 1.0d-5         ! Relative tolerance
    atol   = 1.0d-9         ! Absolute tolerance
    itask  = 1              ! Standard integration until TOUT
    istate = 1              ! First call to the problem
    iopt   = 0              ! No optional inputs
    mf     = 22             ! Stiff method, internally generated full Jacobian
    lrw    = 22 + 9*neq + neq**2
    liw    = 22 + neq
    allocate(iwork(liw))
    allocate(rwork(lrw))

    ! Integrate model equations
    do i = 2, Nsteps
        call dlsode (model_eqs, neq, Y, T, TOUT, ITOL, RTOL, ATOL, ITASK,   &
                    ISTATE, IOPT, RWORK, LRW, IWORK, LIW, JAC, MF)
        istate = 2              ! Next call to LSODE is subsequent
        ! Update TOUT
        tout = t + tstep
        ! Store current point of solution
        yout(:,i) = y(:)
    end do
    deallocate(iwork,rwork)
    return
end subroutine simulate_model

!----------------------------------------------------------------------------------------

subroutine model_output(neq, Nsteps, tstep, yout)
    !--------------------------------------------------------------
    implicit none
    !--------------------------------------------------------------
    ! Declare variables
    integer :: neq                  ! Number of ODEs in macro-scale model
    integer :: Nsteps               ! Number of calls to LSODE
    real(8) :: tstep                ! Time step for results output (ODE), s

    real(8) :: yout(neq, Nsteps)    ! Matrix of integration output

    integer :: i                    ! Loop variable

    ! Output results to the console
    print *, 'Time (s)', 'Prey', 'Predator'
    do i = 1, Nsteps
        print *, i*tstep, yout(1,i), yout(2,i)
    end do

    open(10, file='output.txt')
    do i = 1, Nsteps
        write(10,*) i*tstep, yout(1,i), yout(2,i)
    end do
    close(10)

    return
end subroutine model_output
