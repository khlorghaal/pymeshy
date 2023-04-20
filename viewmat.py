from numpy import array
from numpy import identity
from numpy import pad
from numpy import matmul
from math import cos
from math import sin
from math import exp
def roty(t):
    c= cos(t)
    s= sin(t)
    return array((
        [1, 0, 0],
        [0, c,-s],
        [0, s, c]
    ))

def rotx(t):
    c= cos(t)
    s= sin(t)
    return array((
        [ s,0,c],
        [ 0,1,0],
    	[-c,0,s]
    ))

from dataclasses import dataclass

@dataclass
class state:
    r= [0,0]
    t= [0,0,0]
    s= 1
    z= -6
    def do(*a): return do(*a)

@dataclass
class mats:
    v: array
    p: array


def do(state,w,h):
    v= identity(3,dtype='float')#view
    p= identity(4,dtype='float')#projection
    r= state.r
    z= state.z
    s= state.s
    asp= h/w

    x= r[0]*6.28
    y= r[1]*3.14
    v= matmul(roty(-y),rotx(x))*exp(z*.25)
    fov= .3
    p= array([
        [asp,0,  0, 0],
        [0,1,  0, 0],
        [0,0,2**-11, 0],
        [0,0,fov, 1]
        ])
    v= pad(v,(0,1),mode='constant',constant_values=0)
    v*= s

    v[-1,-1]=1
    v=v.flatten()
    p=p.flatten()


    return mats(v,p)