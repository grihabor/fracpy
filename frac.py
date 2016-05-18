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
                            
                    
def koch_curve(p):
    t = rotate(rot(p), pi/2)
    yield point(loc(p) + t, rot(p)/3)
    t = rotate(rot(p), -pi/2)
    yield point(loc(p) + t, rot(p)/3)
    
    t = rotate(rot(p), pi/6)
    yield point(loc(p) + t/2, rotate(rot(p), pi/3)/3)
    t = rotate(rot(p), -pi/6)
    yield point(loc(p) + t/2, rotate(rot(p), -pi/3)/3)
    raise StopIteration
    
def serpinsky(p):
    t = rot(p)/2
    yield point(loc(p) + t, t)
    t2 = rotate(rot(p), 2*pi/3)/2
    yield point(loc(p) + t2, t)
    t2 = rotate(rot(p), -2*pi/3)/2
    yield point(loc(p) + t2, t)
    raise StopIteration

def dragon(p):    
    k = sqrt(2)/2
    t1 = rotate(rot(p), -pi/4)*k
    t2 = rotate(rot(p), -3*pi/4)*k
    yield point(loc(p) - t1, t1)
    yield point(loc(p) + t2, t2)
    raise StopIteration
    
def calculate(rec_function, img_size, n_iterations, init_loc=None, init_rot=None):
    
    if init_loc is None:
        init_loc = [img_size//2, img_size//2]
    if init_rot is None:
        init_rot = [0, -100]
    #starting point
    init=point(init_loc, init_rot)
    
    img = np.zeros((img_size,img_size,3), np.float32)
    
    #list of iterators
    it_list = [None]*n_iterations
    
    #flag if we need a new generator
    add_gen = True
    p = init
    i = 0
    while i >= 0:
        if add_gen:
            it_list[i] = iter(rec_function(p))
        add_gen = True
        
        try:
            p = next(it_list[i])
        except StopIteration:
            i -= 1
            add_gen = False
            continue
            
        if i == n_iterations - 1:
            '''
            if stage < .5:
                color = [1., 2*stage, 0.]
            else:
                color = [2 - 2*stage, 1., 0.]
            '''
            color = [1., 0., 0.]
            img[int(loc(p)[1]+.5), int(loc(p)[0]+.5)] = np.array(color)
            add_gen = False
            i -= 1
        else:
            i += 1
    
    return img    
        
