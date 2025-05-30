import numpy as np
import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d import Axes3D  # Required for 3D plotting

plt.rcParams.update({
    'font.size': 14,         # Global text
    'axes.titlesize': 16,    # Titles
    'axes.labelsize': 14,    # X and Y labels
    'legend.fontsize': 12,   # Legend text
    'xtick.labelsize': 12,   # X tick labels
    'ytick.labelsize': 12    # Y tick labels
})

# Load data
data1 = np.loadtxt("C:\\Fortran projects\\Dynamical-Systems\\Poincare\\output.txt")
data2 = np.loadtxt("C:\\Fortran projects\\Dynamical-Systems\\Poincare\\intersections.txt")

# Extract columns from data1:
# x: 2nd column (index 1), y: 3rd column (index 2), z: 4th column (index 3)
x = data1[:, 1]
y = data1[:, 2]
z = data1[:, 3]

# Extract the intersection points from data2
x_intersections = data2[:, 0]
y_intersections = data2[:, 1]
z_intersections = data2[:, 2]

# Create a new figure with 2 subplots side-by-side
fig = plt.figure(figsize=(12, 6))

# Left subplot: 3D plot of Lorenz Attractor
ax1 = fig.add_subplot(1, 2, 1, projection='3d')
ax1.plot(x, y, z, linewidth=0.5, color='blue')
ax1.scatter(x_intersections, y_intersections, z_intersections, marker='x', color='red', s=35, label='Priesečníky v dy(2)/dt = 0')
ax1.view_init(elev=50, azim=-60)
ax1.set_xlabel("osa x")
ax1.set_ylabel("osa y")
ax1.set_zlabel("osa z")
ax1.set_title("Lorenzov atraktor")
ax1.grid(True)
ax1.legend()

# Right subplot: 2D XY plot at z = 35 (Poincare section)
ax2 = fig.add_subplot(1, 2, 2)
ax2.scatter(x_intersections, y_intersections, color='red', s=35)
ax2.set_title(r"$\bf{Poincareho\ zobrazenie}$" "\nPriesečníky v dy(2)/dt = 0")
ax2.set_xlabel("osa x")
ax2.set_ylabel("osa y")
ax2.grid(True)

plt.tight_layout()
plt.savefig("C:\\Fortran projects\\Dynamical-Systems\\Exported figures\\poincare_f2.pdf", format="pdf", dpi=500, bbox_inches='tight')
plt.show()