import numpy as np
import matplotlib.pyplot as plt

plt.rcParams.update({
    'font.size': 14,
    'axes.titlesize': 16,
    'axes.labelsize': 14,
    'legend.fontsize': 12,
    'xtick.labelsize': 12,
    'ytick.labelsize': 12
})

data = np.loadtxt("C:\\Fortran projects\\Dynamical-Systems\\Parameter Mapping\\output.txt")
stable_data = np.loadtxt("C:\\Fortran projects\\Dynamical-Systems\\Parameter Mapping\\output_stable.txt")
unstable_data = np.loadtxt("C:\\Fortran projects\\Dynamical-Systems\\Parameter Mapping\\output_unstable.txt")

# Extract columns
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

# Vytvorenie prvej figúry a uloženie
fig = plt.figure()
plt.plot(x_stable, y_stable, color='black', label='Stabilné riešenie', linewidth=3)
plt.plot(x_unstable, y_unstable, linestyle='--', color='red', label='Nestabilné riešenie', linewidth=3)
plt.xlabel('Damköhlerovo kriterium')
plt.ylabel('Konverzia')
plt.grid(True)
plt.legend()
fig.savefig("C:\\Fortran projects\\Dynamical-Systems\\Exported figures\\mapping.pdf", format="pdf", dpi=300)

# Vytvorenie druhej figúry a jej uloženie
fig = plt.figure()
plt.scatter(eigRe1, eigIm1, marker='o', color='green', label='Vlastné číslo 1', s=35)
plt.scatter(eigRe2, eigIm2, marker='o', color='orange', label='Vlastné číslo 2', s=35)
plt.axvline(x=0, color='black', linestyle='--', linewidth=3)
plt.xlabel('Realmarna časť')
plt.ylabel('Imaginárna časť')
plt.grid(True)
plt.legend()
fig.savefig("C:\\Fortran projects\\Dynamical-Systems\\Exported figures\\eigen_values.pdf", format="pdf", dpi=300)

plt.show()
