import numpy as np
from math import *

'''
one point is represented by location and rotation vectors
[[1, 1], [-1, 0]]
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
                    
def rec(p):
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


img_size = 400
    
vec_list = [point([img_size//2, img_size//2], [0, -100])]

img = np.zeros((img_size,img_size), np.float32)

n_iterations = 8

for i in range(n_iterations):
    upd_list = []
    #print([x.astype(np.int) for x in vec_list])
    for v in vec_list:
        img[int(loc(v)[1]+.5), int(loc(v)[0]+.5)] = (i+1)/n_iterations
        upd_list.extend(np.array(rec(v)))
    vec_list = upd_list
    
import matplotlib.pyplot as plt

plt.imshow(img, cmap='gray', interpolation='None')
plt.show()