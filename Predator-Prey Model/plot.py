import numpy as np
import matplotlib.pyplot as plt

data = np.loadtxt(r"C:\Fortran projects\Dynamical-Systems\Predator-Prey Model\output.txt")

x = data[:, 0]
y2 = data[:, 1]
y3 = data[:, 2]

# Create subplots: 2 rows, 1 column
fig, axs = plt.subplots(2, 1, figsize=(8, 10))

# First subplot: Time vs Population
axs[0].plot(x, y2, label='Prey', color='blue')
axs[0].plot(x, y3, label='Predator', color='orange')
axs[0].set_title("Predator-Prey Model")
axs[0].set_xlabel("Time [seconds]")
axs[0].set_ylabel("Population")
axs[0].legend()
axs[0].grid(True)

# Second subplot: Phase plot (Prey vs Predator)
axs[1].plot(y2, y3, color='black')
# Overlay stationary states [0,0] and [1.25,2]
axs[1].scatter([0, 1.25], [0, 2], color='red', zorder=5, label="Stationary states")
axs[1].set_xlabel("Prey population")
axs[1].set_ylabel("Predator population")
axs[1].set_title("Phase Plot")
axs[1].legend()
axs[1].grid(True)

plt.tight_layout()
plt.show()