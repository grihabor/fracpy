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

                    
alpha = pi/12                    
                    
def koch(p):
    point_list = []
    
    t = rotate(rot(p), pi/2)
    point_list.append(point(loc(p) + t, rot(p)/3))
    t = rotate(rot(p), -pi/2)
    point_list.append(point(loc(p) + t, rot(p)/3))
    
    t = rotate(rot(p), pi/6)
    point_list.append(point(loc(p) + t/2, rotate(rot(p), pi/3)/3))
    t = rotate(rot(p), -pi/6)
    point_list.append(point(loc(p) + t/2, rotate(rot(p), -pi/3)/3))
        
    return point_list

def serpinsky(p):
    point_list = []

    t = rot(p)/2
    point_list.append(point(loc(p) + t, t))
    t2 = rotate(rot(p), 2*pi/3)/2
    point_list.append(point(loc(p) + t2, t))
    t2 = rotate(rot(p), -2*pi/3)/2
    point_list.append(point(loc(p) + t2, t))
    
    return point_list

def dragon(p):
    point_list = []
    
    k = sqrt(2)/2
    t1 = rotate(rot(p), -pi/4)*k
    t2 = rotate(rot(p), -3*pi/4)*k
    point_list.append(point(loc(p) - t1, t1))
    point_list.append(point(loc(p) + t2, t2))
        
    return point_list


n_iterations = 16
img_size = 500
img = np.zeros((img_size,img_size,3), np.float32)

#this function defines the fractal shape
rec_function = dragon
#initial list of points
vec_list = [point([img_size//2, img_size//2], [0, -120])]

for i in range(n_iterations):
    upd_list = []
    print([x.astype(np.int) for x in vec_list])
    print('it', i)
    for j, v in enumerate(vec_list):
        #stage = (i+1)/n_iterations
        stage = 1
        if i != n_iterations - 1:
            k = 0
        else:
            k = 1
            stage = j/(len(vec_list)-1)
        
        
        if stage < .5:
            color = [1., 2*stage, 0.]
        else:
            color = [2 - 2*stage, 1., 0.]
        
        
        img[int(loc(v)[1]+.5), int(loc(v)[0]+.5)] = k*np.array(color)
        upd_list.extend(np.array(rec_function(v)))
    vec_list = upd_list
    
import matplotlib.pyplot as plt

plt.imshow(img, cmap='gray', interpolation='None')
plt.show()
