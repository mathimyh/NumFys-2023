# 1.2 Preliminary task
- I would think that it would then be somewhere around 4 * 3^300 = 4.15e180. It would not be as large since some of these would probably "crash" with each other
- It would take around 4.15e168 seconds. Quite a long time
- Assuming an unsigned int with 128 bits, largest integer is 2^128 - 1. Not enough!! Largest Float


# 2 Tasks
The monomers in my system can only move in the ways similar to the example given: Only 
## 2.3 
The negative value of J implies that the monomers are attracted to one another when they are neighbours. 

## 2.5
We can see that the energies, RoGs, and end-end distances are closely related and are for the most part proportional to each other. The tertiary structures that appear seem to be quite random, as all 3 parameters vary a lot. Still there is a common trend that they all have some decrease when the number of sweeps go up. 

## 2.6
Now with a lower temperature there are far less steps with positive delta_e that is taken, meaning that the tertiary structures will be more and more compact. This is very clearly seen in the plots, as all 3 parameters drop fast and stay at a steady state. For the energy, it seems that after around 300 sweeps it stabilizes. 

## 2.7 
a) The trend is that it takes a longer time to find equilibrium as T increases. For N = 15 the plots for T larger than 2 are chaotic, which could make sense as the small number of acids makes the tertiary structures too simple to "hold together" when the T increases. For N = 50, however, its seen that even for T = 10 the energies converge. Now the tertiary structures are so large that the energies in their nearest neighbour bonds can hold them together for a far larger temperature. 
b) One way to find a starting point: Find the mean in one interval, compare to next interval. If difference in mean is small enough: start sampling for time average. 
c) It seems that the critical temperature is around 2.5. 
