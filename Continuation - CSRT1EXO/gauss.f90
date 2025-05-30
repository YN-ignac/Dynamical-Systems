! This subroutine performs Gaussian elimination with pivoting to solve a system of linear equations.
! It also computes the Newton corrections and the tangent vector for a given system of equations.

! The subroutine takes in the number of equations, the number of variables, the maximum size of the system,
! the coefficient matrix, the right-hand side vector, and arrays for the delta and tangent vector.

! It returns the index of the independent variable, an error code, and modifies the input arrays.
!------------------------------------------------------------------------
   ! Based on the original code by professor M. Kubíček
!------------------------------------------------------------------------
subroutine gauss(n, n1, nmax, a, b, delta, tanv, kfix, ierr)
!------------------------------------------------------------------------
  implicit none
!------------------------------------------------------------------------

  ! Input parameters
  integer, intent(in) :: n, n1, nmax

  ! Inout/output parameters
  integer, intent(out) :: kfix, ierr
  real(8), intent(inout) :: a(nmax, nmax+1), b(nmax+1)
  real(8), intent(out) :: delta(nmax+1), tanv(nmax+1)

  ! Local variables and arrays
  real(8) :: pref(nmax+1), bold(nmax+1)
  real(8) :: y(nmax+1), x(nmax+1)
  integer :: irr(nmax+1), irk(nmax+1)
  integer :: i, j, id, ir, is
  real(8) :: amax, p, s

  !---------------------------------------------------------------------
  ! Initialize the independent variable index and error code
  ! Save a copy of the right-hand side vector
  do i = 1, n1
     bold(i) = b(i)
  end do

  ierr = 0
  do i = 1, n1
     irk(i) = 0
     irr(i) = 0
     pref(i) = 1.0d0
  end do

  !----------------------------------------------------------------------
  ! Set the pivoting preference for the variables
  ! Gaussian elimination with pivoting
  do id = 1, n
     ir = 1
     is = 1
     amax = 0.0d0
     do i = 1, n
        if (irr(i) == 0) then
           do j = 1, n1
              p = pref(j) * abs(a(i, j))
              if (p > amax) then
                 ir = i
                 is = j
                 amax = p
              end if
           end do
        end if
     end do

     if (amax == 0.0d0) then
        ierr = 1
        return
     end if

     irr(ir) = is
     do i = 1, n
        if (i /= ir .and. a(i, is) /= 0.0d0) then
           p = a(i, is) / a(ir, is)
           do j = 1, n1
              a(i, j) = a(i, j) - p * a(ir, j)
           end do
           a(i, is) = 0.0d0
           b(i) = b(i) - p * b(ir)
        end if
     end do
  end do

  !----------------------------------------------------------------------
  ! Back substitution and computing Newton corrections
  do i = 1, n
     ir = irr(i)
     x(ir) = b(i) / a(i, ir)
     irk(ir) = 1
  end do

  !----------------------------------------------------------------------
  ! Find the index of the independent variable (one not used as a pivot)
  do i = 1, n1
     if (irk(i) == 0) then
        kfix = i
     end if
  end do

  !----------------------------------------------------------------------
  do i = 1, n
     ir = irr(i)
     y(ir) = -a(i, kfix) / a(i, ir)
  end do

  do i = 1, n1
     b(i) = x(i)
     delta(i) = y(i)
  end do

  b(kfix) = 0.0d0
  delta(kfix) = 1.0d0

  !----------------------------------------------------------------------
  ! Normalize the delta vector
  s = 0.0d0
  do i = 1, n1
     s = s + delta(i)**2
  end do
  do i = 1, n1
     delta(i) = delta(i) / sqrt(s)
  end do

  !----------------------------------------------------------------------
  ! Set the tangent vector and restore b
  do i = 1, n1
     tanv(i) = delta(i)
     delta(i) = b(i)
     b(i) = bold(i)
  end do

  return
end subroutine gauss
