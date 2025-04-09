import numpy as np
import matplotlib.pyplot as plt

# Load the data from the file (adjust delimiter or header options if needed)
data = np.loadtxt("C:\Fortran projects\Dynamical-Systems\Parameter Mapping\output.txt")

# Extract the third column (index 2) for x-axis and the first column (index 0) for y-axis
x = data[:, 2]
y = data[:, 0]

plt.figure()
plt.plot(x, y, 'o-', label='Data')
plt.xlabel('Third Column')
plt.ylabel('First Column')
plt.title('Plot of First Column vs Third Column')
plt.grid(True)
plt.legend()
plt.show()

