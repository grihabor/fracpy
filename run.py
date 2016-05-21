from frac import *

def white(j):
    return [255, 255, 255]

def color_lin(j):
    j //= 100
    a = j % 511
    b = 510 - a
    y = min(a, b)
    return [y, 0, 255-y]
    
def color_sin(j):
    return [sin(j)*255, 0, cos(j)*255]

img_size = 500

#img = calculate(dragon, img_size, 18, color_lin, init_rot=[0, -img_size*.25])
#img = calculate(koch_curve, img_size, 8, color_lin, init_rot=[img_size*.3, -img_size*.3])
#img = calculate(sierpinski_triangle, img_size, 11, color_lin, init_rot=[0, -img_size*.45], init_loc=[img_size//2, 2*img_size//3])


#img = calculate(sierpinski_carpet, 800, 7, color_lin, init_rot=[0, -3**6])

img = calculate(levy_curve, img_size, 18, color_lin, gamma=img_size/12)

SAVE_TO_FILE = True

if SAVE_TO_FILE:
    from skimage.io import imsave

    imsave("frac.png", img)

else:
    import matplotlib.pyplot as plt

    plt.imshow(img, interpolation='None')
    plt.show()

