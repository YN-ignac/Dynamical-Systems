import numpy as np
import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d import Axes3D 

data = np.loadtxt("C:\\Fortran projects\\Dynamical-Systems\\Poincare\\output.txt")

# Extract columns:
# x: 2nd column (index 1)
# y: 3rd column (index 2)
# z: 4th column (index 3)
x = data[:, 1]
y = data[:, 2]
z = data[:, 3]

# Create a new figure for 3D plotting
fig = plt.figure()
ax = fig.add_subplot(111, projection='3d')

# Create a scatter plot
ax.plot(x, y, z, linewidth=0.5)

# Label the axes
ax.set_xlabel("x-axis")
ax.set_ylabel("y-axis")
ax.set_zlabel("z-axis")

plt.title("Lorenz Attractor")
plt.grid(True)
plt.show()