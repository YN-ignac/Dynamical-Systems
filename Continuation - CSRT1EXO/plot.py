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

data = np.loadtxt("C:\Fortran projects\Dynamical-Systems\Continuation - CSRT1EXO\output.txt")

X = data[:, 0]
theta = data[:, 1]
Da = data[:, 2]

plt.figure()
plt.plot(Da, X, color='blue', lw='3', marker='o')
plt.xlabel('Damköhlerovo kriterium')
plt.ylabel('Konverzia')
plt.grid(True)
# Save the first graph as a high-resolution PDF
plt.savefig("continuation.pdf", format="pdf", dpi=300)

plt.figure()
plt.plot(theta, X, lw='2')
plt.xlabel('Damköhlerovo kriterium')
plt.ylabel('Bezrozmerná teplota')
plt.grid(True)

plt.figure()
plt.plot(theta, X, lw='2')
plt.xlabel('Bezrozmerná teplota')
plt.ylabel('Konverzia')
plt.grid(True)

plt.show()