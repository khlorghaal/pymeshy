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
    m= (0,0)
    z= 0
    def do(s):
        return do(s)

@dataclass
class mats:
    v: array
    p: array


def do(state):
    v= identity(3,dtype='float')#view
    p= identity(4,dtype='float')#projection
    m= state.m
    z= state.z

    x= m[0]*6.28
    y= m[1]*3.14
    v= matmul(roty(y),rotx(x))*exp(z*.25)
    fov= .25
    p= array([
        [1,0,  0, 0],
        [0,1,  0, 0],
        [0,0,fov,.25],
        [0,0,fov, 1]
        ])
    v= pad(v,(0,1),mode='constant',constant_values=0)
    v[-1,-1]=1
    v=v.flatten()
    p=p.flatten()


    return mats(v,p)