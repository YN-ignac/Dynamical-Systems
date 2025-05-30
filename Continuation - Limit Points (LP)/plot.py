import numpy as np
import matplotlib.pyplot as plt

plt.rcParams.update({
    'font.size': 14,         # Global text
    'axes.titlesize': 16,    # Titles
    'axes.labelsize': 14,    # X and Y labels
    'legend.fontsize': 12,   # Legend text
    'xtick.labelsize': 12,   # X tick labels
    'ytick.labelsize': 12    # Y tick labels
})

data = np.loadtxt("C:\Fortran projects\Dynamical-Systems\Continuation - Limit Points (LP)\output.txt")

X = data[:, 0]
theta = data[:, 1]
Da = data[:, 2]
beta = data[:, 3]

plt.figure()
plt.plot(Da, beta, lw='3', color='blue')
plt.title('Bifurkačný diagram - limitné body')
plt.xlabel('Damköhlerovo kriterium')
plt.ylabel('Beta')
plt.grid(True)
# Save the first graph as a high-resolution PDF
plt.savefig("C:\\Fortran projects\\Dynamical-Systems\\Exported figures\\limit_points.pdf", format="pdf", dpi=300)

plt.show()