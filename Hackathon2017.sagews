︠2306cf22-37fe-41af-8968-76b5138da81ds︠
import numpy as np
from scipy.optimize import fsolve
from scipy import ndimage as nd

# All units are in MKS
# User declares the desired orbit height and eccentricity.
# User must declare the desired end time of computation, and the number of timesteps (e.g. start at t=0 and go to t=1000 in 11 steps of size 100 seconds)


t = var('t')
#height of orbit above surface
h = 5000000
#eccentricity of orbit
ecc = 0.2
a = p/(1-ecc^2)
# maxtime and num steps determines the number of times the code computes the satellite's position at a given time. 
maxtime = 12000
numsteps = 24 + 1


# mass of satellite
m = 5000
# radius of planet
R_e = 6378.1*1000
#height of orbit above centre of planet
p = R_e+h
#mass of planet
M_e = 5.972*10^24
# Gravitational constant
G = 6.67408*10^(-11)
︡bd6b961a-20ca-4302-96a9-5d3fd8b3e172︡{"done":true}︡
︠7c0008f1-0d42-4a41-a2e3-c57683477d71s︠
def M(t):
    return np.sqrt((G*(M_e + m))/(p/(1-ecc^2))^3)*t

def M_list(maxtime, steps):
    eset = []
    for time in np.linspace(0, maxtime , steps):
        eset.append(M(time))
    return eset

myM_list = M_list(maxtime, numsteps)

def Egen():
    eset = []
    for myM in myM_list:
        def f(E):
            return E - ecc*sin(E) - myM
        eset.append(fsolve(f, 0)[0])
    return eset

def radiusgen():
    eset = []
    for item in Egen():
        eset.append(a*(1-ecc*cos(item)))
    return eset

def thetagen():
    thetaset = []
    eset = []
    for i in Egen():
        thetaset.append(tan(i/2)*((1+ecc)/(1-ecc))^0.5)
    theta = 2*np.arctan(thetaset)
    for k in theta:
        eset.append(k)
    return eset

Earth = circle((0,0),R_e, facecolor = 'green', fill=True)

def plot_orbit():
    return polar_plot((R_e+h)/(1+ecc*cos(x)), (x, 0, 2*pi))

orbit = plot_orbit()

def plotgen():
    eset = []
    for ra, th in zip(radiusgen(), thetagen()):
        eset.append((ra*cos(th), ra*sin(th)))
    return eset

scatter = scatter_plot(plotgen())

def time_dict():
    elementsAtT = []
    for ra, th in zip(radiusgen(), thetagen()):
        elementsAtT.append((ra*cos(th), ra*sin(th)))  
    coord_dict = {time:[] for time in np.linspace(0, maxtime, numsteps)}
    for i,time in enumerate(np.linspace(0, maxtime, numsteps)):
        coord_dict[time] = elementsAtT[i]
    return coord_dict

def position_at_time(mytime):
    eset = [Earth + orbit]
    if mytime in np.linspace(0, maxtime, numsteps):
        eset.append(scatter_plot([time_dict()[mytime]]))
    else:
        print 'timestep error'
    return sum(eset)

def plotter():
    return plot(Earth + orbit + scatter).show(aspect_ratio=1)
︡17286da9-bcdb-42d0-8c2e-c187ff66e3d8︡{"done":true}︡
︠06d5718e-1f3c-430b-b445-75343b7b0adbs︠
# plots the trace of the orbit (shows all points at which we calculate the position for the given end time and timestep)
plotter()


︡8d2b3850-4870-4ccc-86ed-e8860c44216f︡{"file":{"filename":"/home/user/.sage/temp/project-11bff783-33b5-4446-87b0-2a057021fd31/50364/tmp_V83CHS.svg","show":true,"text":null,"uuid":"630163bc-978c-4483-b002-d75a850ec52f"},"once":false}︡{"done":true}︡
︠4563d1e7-73a2-4a8f-8a34-0b9bbb640ccc︠
# prints the time values the user can enter to see the position at that time.
np.linspace(0, maxtime, numsteps)
# returns the position at a given time value (the given value must be in the array defined by the stop time and timestep)
position_at_time(500)
︡9a78c7cc-ddad-49b1-8f89-610614a9c932︡{"stdout":"array([     0.,    500.,   1000.,   1500.,   2000.,   2500.,   3000.,\n         3500.,   4000.,   4500.,   5000.,   5500.,   6000.,   6500.,\n         7000.,   7500.,   8000.,   8500.,   9000.,   9500.,  10000.,\n        10500.,  11000.,  11500.,  12000.])\n"}︡{"file":{"filename":"/home/user/.sage/temp/project-11bff783-33b5-4446-87b0-2a057021fd31/50364/tmp__9C3Fq.svg","show":true,"text":null,"uuid":"175dce95-b0af-4c44-809a-bef1c8f78286"},"once":false}︡{"done":true}︡
︠7fa69905-ee4f-4bb2-83f3-e35e7f0e1a87︠









