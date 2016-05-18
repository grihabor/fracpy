from frac import *

def color(j):
    a = j % 511
    b = 510 - a
    y = min(a, b)
    return [y, 0, 255-y]
    
img_size = 600

#img = calculate(dragon, 500, 18)
#img = calculate(koch_curve, 500, 8)
#img = calculate(serpinsky, img_size, 11, init_rot=[0, -300], init_loc=[img_size//2, 2*img_size//3])

img = calculate(levy_curve, 500, 17, color)

SAVE_TO_FILE = True

if SAVE_TO_FILE:
    from skimage.io import imsave

    imsave("frac.png", img)

else:
    import matplotlib.pyplot as plt

    plt.imshow(img, interpolation='None')
    plt.show()

