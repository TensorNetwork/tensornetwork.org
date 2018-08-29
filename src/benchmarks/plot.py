# Author: Paul Springer (springer@aices.rwth-aachen.de)

import numpy as np
import matplotlib.pyplot as plt
import matplotlib


def main():
    #######################################################
    # ADD your DATA HERE
    #######################################################

    arithmeticIntensity = getArithmeticIntesity("./data/fp64/haswell_e5_2680_v3/tblis.dat")
    tcl = readFlops("./data/fp64/haswell_e5_2680_v3/tccg.dat", 12, arithmeticIntensity )
    tblis = readFlops("./data/fp64/haswell_e5_2680_v3/tblis.dat", 4, arithmeticIntensity )
    tt = readFlops("./data/fp64/haswell_e5_2680_v3/tt_2.6.dat", 4, arithmeticIntensity )
    itensor = readFlops("./data/fp64/haswell_e5_2680_v3/itensor.dat", 4, arithmeticIntensity )
    eigen = readFlops("./data/fp64/haswell_e5_2680_v3/eigen.dat", 4, arithmeticIntensity )
    numpy = readFlops("./data/fp64/haswell_e5_2680_v3/numpy.dat", 6, arithmeticIntensity )

    dat = [ 
            ("Eigen",'v', eigen),
            ("numpy",'<',numpy),
            ("ITensor",'o',itensor),
            ("Tensor Toolbox",'>',tt),
            ("TBLIS",'d',tblis),
            ("TCL", '^',tcl)]

    plot(dat, "randomTC.png")
    analyzeFlops(dat)


def plot(data, filename, isSpeedup = 0):
    fig = plt.figure()
    fig.set_size_inches(12, 6)
    plt.xlim((0, 1000))
    ax = fig.add_subplot(111)
    ax.get_yaxis().set_major_formatter(matplotlib.ticker.ScalarFormatter())
    ax.set_axis_bgcolor((248/256., 248/256., 248/256.))
    ax.set_ylabel('GFLOPs /s',fontsize=22)

    for (label, marker, flops) in data:
        ax.plot(flops, label=label, marker=marker, markeredgewidth=0.0, lw = 0, clip_on=False, zorder=10)

    ax.set_xlabel('#test case',fontsize=22)
    for item in ax.get_xticklabels():
        item.set_fontsize(22)
    for item in ax.get_yticklabels():
        item.set_fontsize(24)
    ax.legend( loc ='upper left', numpoints = 1, markerscale=2., handletextpad=0.05)
    plt.savefig(filename, bbox_inches='tight', transparent=False)
    plt.close()

def analyzeFlops(data):
    print "".ljust(15) + "min".ljust(10) + "avg".ljust(10) + "max"
    for (label, marker, flops) in reversed(data):
        print label.ljust(15) + ("%.2f"%min(flops)).ljust(10) + ("%.2f"%np.mean(flops)).ljust(10) + "%.2f"%np.max(flops)

def readFlops(filename, column, sortAccordingTo):
    flops = []
    f = open(filename,"r")
    for l in f:
        flops.append(float(l.split()[column]))

    flops = np.array([f for _,f in sorted(zip(sortAccordingTo,flops))])
    return flops 

def getArithmeticIntesity(filename):
    arithmeticIntesity = []
    f = open(filename,"r")
    for l in f:
        tokens = l.split()
        arithmeticIntesity.append(float(tokens[1]) * float(tokens[2]) * float(tokens[3])/ (float(tokens[1])*float(tokens[2]) + float(tokens[1])*float(tokens[3]) + float(tokens[2])*float(tokens[3])))
    return np.array(arithmeticIntesity)

if __name__ == "__main__":
    main()
