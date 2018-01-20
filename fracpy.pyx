import numpy as np
from point cimport create_point, Point, rotate



def calculate(*, apply_tree, int img_size, n_iterations, color, float size=100, float alpha=0):
    '''
    gen_func        - point generator
    img_size        - output image size
    n_iterations    - number of iterations
    color           - function, which takes point number from (0, N**n_iterations)
                        where N - generator number of points
    '''


    cdef float up[2]
    cdef Point initial_point
    cdef float rotation[2]

    up[0] = 0
    up[1] = size
    rotation = rotate(up, alpha)

    initial_point = create_point(
        [img_size / 2, img_size / 2],
        rotation
    )

    tree_counter = apply_tree(initial_point).shape[0]

    # total number of points
    total = tree_counter ** n_iterations

    img = np.zeros((img_size,img_size,3), np.float)

    # list of iterators
    it_list = [None]*n_iterations

    point_buffer = np.array([[initial_point]])

    cdef unsigned int i
    cdef unsigned int j
    cdef Point point

    for i in range(10):
        point_buffer.reshape((-1,))
        new_point_buffer = np.zeros((point_buffer.shape[0], tree_counter), dtype=np.float32)

        for j, point in enumerate(point_buffer):
            new_point_buffer[i, :] = apply_tree(point)

        point_buffer = new_point_buffer

    point_buffer.reshape((-1,))
    for point in point_buffer:
        img[point.position] = [1., 1., 1.]

    #print(n_iterations, count, total)
    return img