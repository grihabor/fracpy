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
    def get(p):
        t = rotate(rot(p), pi/2)
        yield point(loc(p) + t, rot(p)/3)
        t = rotate(rot(p), -pi/2)
        yield point(loc(p) + t, rot(p)/3)
        
        t = rotate(rot(p), pi/6)
        yield point(loc(p) + t/2, rotate(rot(p), pi/3)/3)
        t = rotate(rot(p), -pi/6)
        yield point(loc(p) + t/2, rotate(rot(p), -pi/3)/3)
        raise StopIteration
    
class sierpinski_triangle:
    def get(p):
        t = rot(p)/2
        yield point(loc(p) + t, t)
        t = rotate(rot(p), 2*pi/3)/2
        yield point(loc(p) + t, t)
        t = rotate(rot(p), -2*pi/3)/2
        yield point(loc(p) + t, t)
        raise StopIteration

class sierpinski_carpet:
    def get(p):
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
    def get(p):    
        k = sqrt(2)/2
        t1 = rotate(rot(p), -pi/4)*k
        t2 = rotate(rot(p), -3*pi/4)*k
        yield point(loc(p) - t1, t1)
        yield point(loc(p) + t2, t2)
        raise StopIteration




class levy_curve:
    def __init__(self, alpha, num):
        self.alpha = alpha
        self.num = num
        return
        
    def get(self, p):
        beta = self.alpha/2
        k = 2*tan(beta)
        h = rotate(rot(p), -pi/2 + beta) * cos(beta)/2
        for i in range(self.num):
            yield point(loc(p) + h, h*k)
            h = rotate(h, self.alpha)
            
        raise StopIteration


def calculate(obj, img_size, n_iterations, color, size=100, alpha=0, init_loc=None, init_rot=None):
    '''
    rec_function    - point generator
    img_size        - output image size
    n_iterations    - number of point iterations
    color           - function, which takes point number from (0, N**n_iterations)
                        where N - generator number of points
    '''
    rec_function = obj.get
    if init_loc is None:
        init_loc = [img_size//2, img_size//2]
    if init_rot is None:
        init_rot = rotate([0, -size], alpha)
    

    #starting point
    init=point(init_loc, init_rot)
    
    img = np.zeros((img_size,img_size,3), np.uint8)
    
    #list of iterators
    it_list = [None]*n_iterations
    
    #flag if we need a new generator
    add_gen = True
    p = init
    i = 0
    j = 0
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
        '''
        print('iteration', i)
        print('point', p)
        '''
    
        if i == n_iterations - 1:
            img[int(loc(p)[1]+.5), int(loc(p)[0]+.5)] = np.array(color(j))
            j += 1
            add_gen = False
        else:
            i += 1
    
    return img    
        
