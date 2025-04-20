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

# Load data for Hopf bifurcation
data_hopf = np.loadtxt("C:\\Fortran projects\\Dynamical-Systems\\Continuation - Hopf Bifurcations (HP)\\outputHB.txt")
Da_hopf    = data_hopf[:, 2]
beta_hopf  = data_hopf[:, 3]

# Load data for Limit Points
data_lp = np.loadtxt("C:\\Fortran projects\\Dynamical-Systems\\Continuation - Limit Points (LP)\\output.txt")
Da_lp   = data_lp[:, 2]
beta_lp = data_lp[:, 3]

plt.figure()
plt.plot(Da_hopf, beta_hopf, lw=3, color='blue', label='Hopfova bifurkácia')
plt.plot(Da_lp, beta_lp, lw=3, color='red', label='Limitné body', ls='--')
plt.title('Bifurkačný diagram - body Hopfovej bifurkácie a limitné body')
plt.xlabel('Damköhlerovo kriterium')
plt.ylabel('Beta')
plt.grid(True)
plt.legend()
# Save the combined graph as a high-resolution PDF
plt.savefig("combined_bifurcation.pdf", format="pdf", dpi=300)
plt.show()

plt.figure()
plt.plot(Da_hopf, beta_hopf, lw='3', color='blue')
plt.title('Bifurkačný diagram - body Hopfovej bifurkácie')
plt.xlabel('Damköhlerovo kriterium')
plt.ylabel('Beta')
plt.grid(True)
# Save the first graph as a high-resolution PDF
plt.savefig("hopf.pdf", format="pdf", dpi=300)
plt.show()

