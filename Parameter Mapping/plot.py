import numpy as np
import matplotlib.pyplot as plt
import matplotlib.animation as animation

plt.rcParams.update({
    'font.size': 14,         # Global text
    'axes.titlesize': 16,    # Titles
    'axes.labelsize': 14,    # X and Y labels
    'legend.fontsize': 12,   # Legend text
    'xtick.labelsize': 12,   # X tick labels
    'ytick.labelsize': 12    # Y tick labels
})

data = np.loadtxt("C:\\Fortran projects\\Dynamical-Systems\\Parameter Mapping\\output.txt")
stable_data = np.loadtxt("C:\\Fortran projects\\Dynamical-Systems\\Parameter Mapping\\output_stable.txt")
unstable_data = np.loadtxt("C:\\Fortran projects\\Dynamical-Systems\\Parameter Mapping\\output_unstable.txt")

# Extract the third column (Damköhler number) for x-axis and the first column (Conversion) for y-axis
x = data[:, 2]
y = data[:, 0]

eigRe1 = data[:, 3]
eigIm1 = data[:, 4]
eigRe2 = data[:, 5]
eigIm2 = data[:, 6]

x_stable = stable_data[:, 2]
y_stable = stable_data[:, 0]

x_unstable = unstable_data[:, 2]
y_unstable = unstable_data[:, 0]

# Plot the conversion vs. Damköhlerovo kritérium graph
plt.figure()
plt.plot(x_stable, y_stable, color='black', label='Stabilné riešenie', linewidth=3)
plt.plot(x_unstable, y_unstable, linestyle='--', color='red', label='Nestabilné riešenie', linewidth=3) 
plt.xlabel('Damköhlerovo kriterium')
plt.ylabel('Konverzia')
plt.grid(True)
plt.legend()
# Save the first graph as a high-resolution PDF
plt.savefig("conversion_vs_damkohler.pdf", format="pdf", dpi=300)

# Plot the eigen values graph
plt.figure()
plt.scatter(eigRe1, eigIm1, marker='o', color='green', label='Vlastné číslo 1')
plt.scatter(eigRe2, eigIm2, marker='o', color='orange', label='Vlastné číslo 2')
plt.axvline(x=0, color='black', linestyle='--', linewidth=3)
plt.xlabel('Realmarna časť')
plt.ylabel('Imaginárna časť')
plt.grid(True)
plt.legend()
# Save the second graph as a high-resolution PDF
plt.savefig("eigen_values.pdf", format="pdf", dpi=300)

plt.show()
