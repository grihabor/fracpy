# cython: linetrace=True
# distutils: define_macros=CYTHON_TRACE=1 

import numpy as np
from point cimport create_point, Point, rotate, Pair


cdef point_to_tuple(Point p):
    return (p.position.x, p.position.y, p.rotation.x, p.rotation.y)


cdef Point tuple_to_point(item):
    cdef Point point
    point.position.x = item['px']
    point.position.y = item['py']
    point.rotation.x = item['rx']
    point.rotation.y = item['ry']
    return point


def calculate(*,
              fractal,
              tuple canvas_shape,
              int n_iterations,
              color,
              float size=100,
              float angle=0):
    """

    Attributes
    ----------
    fractal
        Fractal function
    canvas_shape: tuple of int
        First 2 dimensions of the output numpy array
    n_iterations: int
        Number of fractal iterations
    color
        Color function

        It should take a float from [0, 1] and return
        a numpy array of shape=(3,) and dtype=np.float32
    size: float
        Size of the fractal
    angle: float
        Rotation of the fractal

    Returns
    -------
    
    """



    cdef Pair up
    cdef Pair rotation
    cdef Pair position

    up.x = 0
    up.y = size
    rotation = rotate(up, angle)

    position.x = canvas_shape[0] / 2
    position.y = canvas_shape[1] / 2

    cdef Point initial_point = create_point(position, rotation)


    tree_counter = fractal(initial_point).shape[0]

    # total number of points
    total = tree_counter ** n_iterations


    point_type = [('px', 'f4'), ('py', 'f4'), ('rx', 'f4'), ('ry', 'f4')]
    point_buffer = np.array([[
        point_to_tuple(initial_point)
    ]], dtype=point_type)

    new_point_buffer = np.array([[]], dtype=point_type)
    img = np.zeros((img_size, img_size, 3), dtype=np.float)

    cdef int i, j, k
    cdef int x, y
    cdef Point point

    for i in range(n_iterations):
        point_buffer = point_buffer.reshape((-1,))
        new_point_buffer = np.zeros((point_buffer.shape[0], tree_counter), dtype=point_type)

        for j in range(point_buffer.shape[0]):
            item = point_buffer[j]
            point = tuple_to_point(item)
            points = fractal(point)

            for k in range(points.shape[0]):
                new_point_buffer[j, k] = point_to_tuple(points[k])

        point_buffer = new_point_buffer

    point_buffer = point_buffer.reshape((-1,))

    for i in range(point_buffer.shape[0]):
        item = point_buffer[i]
        x = item['px']
        y = item['py']
        color_value = color(i / total)
        img[y, x, :] = color_value

    return img