import numpy as np

dz = 6
J = 10


def plotter(dz, J, ka):
    return 2*dz + 2*J *(1-np.cos(ka))

i = 0
while (i<=np.pi):
    print(plotter(dz, J, i))
    i += np.pi/8

