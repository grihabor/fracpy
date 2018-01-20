import numpy as np
from math import sin, cos


def point(loc, rot):
    return np.array([loc, rot])


def loc(p):
    return p[0, :]


def rot(p):
    return p[1, :]


# vector + angle -> vector
def rotate(v, angle):
    return np.array([v[0] * cos(angle) + v[1] * sin(angle),
                     -v[0] * sin(angle) + v[1] * cos(angle)])



def calculate(*, gen_func, img_size, n_iterations, color, size=100, alpha=0, init_loc=None, init_rot=None):
    '''
    gen_func        - point generator
    img_size        - output image size
    n_iterations    - number of iterations
    color           - function, which takes point number from (0, N**n_iterations)
                        where N - generator number of points
    '''


    if init_loc is None:
        init_loc = [img_size//2, img_size//2]
    if init_rot is None:
        init_rot = rotate([0, -size], alpha)

    #starting point
    init=point(init_loc, init_rot)
    #total number of points
    total = sum(1 for i in gen_func(init)) ** n_iterations

    img = np.zeros((img_size,img_size,3), np.float)

    #list of iterators
    it_list = [None]*n_iterations

    #flag if we need a new generator
    add_gen = True
    p = init
    i = 0
    count = 0
    while i >= 0:
        if add_gen:
            it_list[i] = iter(gen_func(p))
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
            img[int(loc(p)[1]+.5), int(loc(p)[0]+.5)] = np.array(color(count/total))
            count += 1
            add_gen = False
        else:
            i += 1
    #print(n_iterations, count, total)
    return img