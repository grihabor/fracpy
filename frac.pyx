import numpy as np
from math import *

'''
one point is represented by location and rotation vectors
[[loc_x, loc_y], [rot_x, rot_y]]
'''

def point(loc, rot):
    return np.array([loc, rot])


def loc(p):
    return p[0,:]


def rot(p):
    return p[1,:]


#vector + angle -> vector
def rotate(v, angle):
    return np.array([v[0] * cos(angle) + v[1] * sin(angle),
                    -v[0] * sin(angle) + v[1] * cos(angle)])
                            


class koch_curve:                    
    def __call__(self, p):
        t = rotate(rot(p), pi/2)
        yield point(loc(p) + t, rot(p)/3)
        t = rotate(rot(p), pi/6)
        yield point(loc(p) + t/2, rotate(rot(p), pi/3)/3)
        t = rotate(rot(p), -pi/6)
        yield point(loc(p) + t/2, rotate(rot(p), -pi/3)/3)
        t = rotate(rot(p), -pi/2)
        yield point(loc(p) + t, rot(p)/3)        
        raise StopIteration


class sierpinski_triangle:
    def __call__(self, p):
        v1 = rot(p)/2
        v2 = rotate(v1, 2*pi/3)
        v3 = rotate(v1, -2*pi/3)
        yield point(loc(p) + v1, v3)
        yield point(loc(p) + v2, v1)
        yield point(loc(p) + v3, v2)
        raise StopIteration


class sierpinski_carpet:
    def __call__(self, p):
        new_rot = rot(p)/3
        t = new_rot
        t2 = rotate(new_rot*sqrt(2), pi/4)
        for i in range(4):
            yield point(loc(p) + t, new_rot)
            t = rotate(t, pi/2)
            yield point(loc(p) + t2, new_rot)
            t2 = rotate(t2, pi/2)

        raise StopIteration


class dragon:
    def __call__(self, p):    
        k = sqrt(2)/2
        t1 = rotate(rot(p), -pi/4)*k
        t2 = rotate(rot(p), -3*pi/4)*k
        yield point(loc(p) - t1, t1)
        yield point(loc(p) + t2, t2)
        raise StopIteration


def peano_curve(p):    
    t1 = rot(p)/2
    t2 = rotate(t1, pi/2)
    yield point(loc(p)-t1-t2, -t2)
    yield point(loc(p)+t1-t2, t1)
    yield point(loc(p)+t1+t2, t1)
    yield point(loc(p)-t1+t2, t2)
    raise StopIteration


def minkowski_curve(p):
    t1 = rot(p)/2
    t2 = rotate(t1, pi/2)
    yield point(loc(p) + 3*t2, t1/2)
    yield point(loc(p) + 2*t2 + t1, t2/2)
    yield point(loc(p) + t2 + 2*t1, t1/2)
    yield point(loc(p) + t1, -t2/2)
    yield point(loc(p) - t1, -t2/2)
    yield point(loc(p) - t2 - 2*t1, t1/2)
    yield point(loc(p) - 2*t2 - t1, t2/2)
    yield point(loc(p) - 3*t2, t1/2)

class levy_curve:
    def __init__(self, alpha, num):
        self.alpha = alpha
        self.num = num
        return
        
    def __call__(self, p):
        beta = self.alpha/2
        k = 2*tan(beta)
        h = rotate(rot(p), -pi/2 + beta) * cos(beta)/2
        for i in range(self.num):
            yield point(loc(p) + h, h*k)
            h = rotate(h, self.alpha)
            
        raise StopIteration

