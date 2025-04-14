import numpy as np
import matplotlib.pyplot as plt

data = np.loadtxt("C:\Fortran projects\Dynamical-Systems\Continuation - CSRT1EXO\output.txt")

X = data[:, 0]
theta = data[:, 1]
Da = data[:, 2]

plt.figure(figsize=(10, 6))
plt.plot(Da, X, lw='2')
plt.xlabel('Damköhlerovo kriterium')
plt.ylabel('Konverzia')
plt.grid(True)

plt.figure(figsize=(10, 6))
plt.plot(theta, X, lw='2')
plt.xlabel('Damköhlerovo kriterium')
plt.ylabel('Bezrozmerná teplota')
plt.grid(True)

plt.figure(figsize=(10, 6))
plt.plot(theta, X, lw='2')
plt.xlabel('Bezrozmerná teplota')
plt.ylabel('Konverzia')
plt.grid(True)

plt.show()