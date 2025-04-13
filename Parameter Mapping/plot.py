import numpy as np
import matplotlib.pyplot as plt
import matplotlib.animation as animation

data = np.loadtxt("C:\Fortran projects\Dynamical-Systems\Parameter Mapping\output.txt")
stable_data = np.loadtxt("C:\Fortran projects\Dynamical-Systems\Parameter Mapping\output_stable.txt")
unstable_data = np.loadtxt("C:\Fortran projects\Dynamical-Systems\Parameter Mapping\output_unstable.txt")

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

# Plot the data
plt.figure()
plt.plot(x, y, 'o', label='Data')
plt.xlabel('Damköhlerovo kriterium')
plt.ylabel('Konverzia')
plt.grid(True)

plt.figure()
plt.plot(x_stable, y_stable, 'o', label='Stabilné riešenie')
plt.plot(x_unstable, y_unstable, 'o', label='Nestabilné riešenie') 
plt.xlabel('Damköhlerovo kriterium')
plt.ylabel('Konverzia')
plt.grid(True)
plt.legend()

plt.figure()
plt.scatter(eigRe2, eigIm2, marker='o', label='Stabilné riešenie')
plt.scatter(eigRe1, eigIm1, marker='o', label='Nestabilné riešenie')
plt.axvline(x=0, color='black', linestyle='--')
plt.xlabel('Realmarna časť')
plt.ylabel('Imaginárna časť')
plt.grid(True)
plt.legend()

plt.show()
