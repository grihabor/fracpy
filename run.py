from frac import *
from skimage.io import imsave
import matplotlib.pyplot as plt

def green(x):
    return [0, 255, 0]

def color_lin(x):
    return [x, 0, 1-x]
    
def color_sin_small(x):
    return [sin(x*pi*512)**2, 0, cos(x*pi*512)**2]

def color_sin(x):
    return [sin(x*pi/2)**2, 0, cos(x*pi/2)**2]

def color3(x):
    x = (3*x + .5) % 3
    if x < 1:
        return [x, 0, 1-x]
    elif x < 2:
        x -= 1
        return [1-x, x, 0]
    else:
        x -= 2
        return [0, 1-x, x]
'''
switch = -1
def color_switch(x):
    global switch
    switch = (switch + 1) % 3
    if switch == 0:
        return [0, 0, 1]
    elif switch == 1:
        return [0, 1, 0]
    elif switch == 2:
        return [1, 0, 0]
'''



img_size = 4000

'''
for i in range(1, 18):
    img = calculate(dragon(), img_size, i, white, init_rot=[0, -img_size*.25])
    imsave("{}.png".format(i), img)
'''



#img = calculate(koch_curve(), img_size, 8, color_sin, init_rot=[img_size*.3, -img_size*.3])

#img = calculate(peano_curve, img_size, 10, color_sin_small, init_rot=[0, -img_size*.45])

img = calculate(minkowski_curve, img_size, 8, color_sin, init_rot=[0, -img_size*.2])
imsave("frac.png", img)
'''
plt.imshow(img, interpolation='None')
plt.show()
'''
'''
img = calculate(sierpinski_triangle(), img_size, 11, color3, init_rot=[0, -img_size*.45], init_loc=[img_size//2, 2*img_size//3])


img = calculate(sierpinski_carpet(), 800, 6, color_lin, init_rot=[0, -3**6])


'''
'''
n = 128
begin = 0
end = n
for i in range(begin, end):
    
    t = i/(n-1)
    alpha = t * pi + (1-t) * 0
    
    curve = levy_curve(alpha, 16)
    img = calculate(curve, img_size, 4, color_sin, size=img_size/3.3)
    print('iteration', i)

    imsave("frames/{}.png".format(i), img)
'''

