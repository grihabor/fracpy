from frac import *

def color_lin(j):
    j //= 9
    a = j % 511
    b = 510 - a
    y = min(a, b)
    return [y, 0, 255-y]
    
def color_sin(j):
    return [sin(j)*255, 0, cos(j)*255]

img_size = 1000

#img = calculate(dragon, 500, 18)
#img = calculate(koch_curve, 500, 8, color, init_rot=[150, -150])
#img = calculate(serpinsky_triangle, img_size, 11, color, init_rot=[0, -300], init_loc=[img_size//2, 2*img_size//3])
img = calculate(serpinsky_carpet, img_size, 7, color_lin, init_rot=[0, -3**6])

#img = calculate(levy_curve, 500, 17, color)

SAVE_TO_FILE = True

if SAVE_TO_FILE:
    from skimage.io import imsave

    imsave("frac.png", img)

else:
    import matplotlib.pyplot as plt

    plt.imshow(img, interpolation='None')
    plt.show()

