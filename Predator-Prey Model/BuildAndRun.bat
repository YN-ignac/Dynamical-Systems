gfortran -ffree-line-length-none -std=legacy *.f *.f90 -o my_executable
.\my_executable.exe
python -u "c:\Fortran projects\Dynamical-Systems\Predator-Prey Model\plot.py"