from fracpy import frac, color
from skimage.io import imsave

DIR_OUTPUT = 'output'

img_size = 700


def main():
    for i in range(1, 18):
        img = frac.calculate(
            gen_func=frac.dragon(),
            img_size=img_size,
            n_iterations=i,
            color=color.linear(
                color_from=color.SKY,
                color_to=color.PINKY,
                zigzag=3
            ),
            init_rot=[0, -img_size * .25])
        imsave("{}/{}.png".format(DIR_OUTPUT, i), img)



    # img = calculate(koch_curve(), img_size, 8, color_sin, init_rot=[img_size*.3, -img_size*.3])

    # img = calculate(peano_curve, img_size, 10, color_sin_small, init_rot=[0, -img_size*.45])

    # img = calculate(minkowski_curve, img_size, 5, color_sin, init_rot=[0, -img_size*.2])

    # imsave("frac.png", img)






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

if __name__ == '__main__':
    main()
