from frac import calculate, dragon

img = calculate(dragon, 500, 18)

SAVE_TO_FILE = True

if SAVE_TO_FILE:
    from skimage.io import imsave

    imsave("frac.png", img)

else:
    import matplotlib.pyplot as plt

    plt.imshow(img, cmap='gray', interpolation='None')
    plt.show()

