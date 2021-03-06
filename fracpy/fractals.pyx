# cython: linetrace=True
# distutils: define_macros=CYTHON_TRACE=1 

import numpy as np
from libc.math cimport pi, sqrt
from point cimport create_point, Point, rotate, Pair



cpdef Pair multiply_by_scalar(Pair arr, float val):
    cdef Pair result
    result.x = arr.x * val
    result.y = arr.y * val
    return result

cpdef Pair divide_by_scalar(Pair arr, float val):
    cdef Pair result
    result.x = arr.x / val
    result.y = arr.y / val
    return result

cpdef Pair negative(Pair arr):
    cdef Pair result
    result.x = -arr.x
    result.y = -arr.y
    return result

cpdef Pair add_arrays(Pair arr1, Pair arr2):
    cdef Pair result
    result.x = arr1.x + arr2.x
    result.y = arr1.y + arr2.y
    return result



cpdef koch_curve(Point p):
    cdef float s = pi / 2
    cdef float k = pi / 3

    cdef Pair t1
    cdef Pair t2
    cdef Pair t3
    cdef Pair t4

    t1 = rotate(p.rotation, s)
    t2 = rotate(p.rotation, s - k)
    t3 = rotate(p.rotation, -s + k)
    t4 = rotate(p.rotation, -s)

    return np.array(
        create_point(
            add_arrays(p.position, t1),
            divide_by_scalar(p.rotation, 3)
        ),
        create_point(
            add_arrays(p.position, divide_by_scalar(t2, 2)),
            divide_by_scalar(rotate(p.rotation, k), 3)
        ),
        create_point(
            add_arrays(p.position, divide_by_scalar(t3, 2)),
            divide_by_scalar(rotate(p.rotation, -k), 3)
        ),
        create_point(
            add_arrays(p.position, t4),
            divide_by_scalar(p.rotation, 3)
        ),
    )

cpdef sierpinski_triangle(Point p):
    cdef:
        Pair v1
        Pair v2
        Pair v3

        float k = 2 * pi / 3

    v1 = divide_by_scalar(p.rotation, 2)
    v2 = rotate(v1, k)
    v3 = rotate(v1, -k)
    return np.array([
        create_point(add_arrays(p.position, v1), v3),
        create_point(add_arrays(p.position, v2), v1),
        create_point(add_arrays(p.position, v3), v2),
    ])


cpdef sierpinski_carpet(Point p):
    cdef:
        Pair new_rot
        Pair t1
        Pair t2

        unsigned int i

    new_rot = divide_by_scalar(p.rotation, 3)
    t1 = new_rot
    t2 = rotate(
        multiply_by_scalar(new_rot, sqrt(2)),
        pi / 4
    )

    result = np.zeros((8,), dtype=create_point)
    for i in range(4):
        result[0 + i * 2] = create_point(add_arrays(p.position, t1), new_rot)
        result[1 + i * 2] = create_point(add_arrays(p.position, t2), new_rot)
        t1 = rotate(t1, pi / 2)
        t2 = rotate(t2, pi / 2)

    return result


cpdef dragon(Point p):
    cdef:
        float k = sqrt(2) / 2
        float q = - pi / 4

        Pair t1
        Pair t2

    t1 = multiply_by_scalar(rotate(p.rotation, q), k)
    t2 = multiply_by_scalar(rotate(p.rotation, 3 * q), k)
    return np.array([
        create_point(add_arrays(p.position, negative(t1)), t1),
        create_point(add_arrays(p.position, t2), t2),
    ])



cpdef peano_curve(Point p):
    cdef:
        Pair t1
        Pair t2

    t1 = divide_by_scalar(p.rotation, 2)
    t2 = rotate(t1, pi / 2)

    return np.array([
        create_point(
            add_arrays(p.position, negative(add_arrays(t1, t2))),
            negative(t2)
        ),
        create_point(
            add_arrays(p.position, add_arrays(t1, negative(t2))),
            t1
        ),
        create_point(
            add_arrays(p.position, add_arrays(t1, t2)),
            t1
        ),
        create_point(
            add_arrays(p.position, add_arrays(negative(t1), t2)),
            t2
        ),
    ])


cpdef minkowski_curve(Point p):
    cdef:
        Pair t1
        Pair t2

    t1 = divide_by_scalar(p.rotation, 2)
    t2 = rotate(t1, pi / 2)

    return np.array([
        create_point(
            add_arrays(p.position, multiply_by_scalar(t2, 3)),
            divide_by_scalar(t1, 2)
        ),
        create_point(
            add_arrays(p.position, add_arrays(multiply_by_scalar(t2, 2), t1)),
            divide_by_scalar(t2, 2)
        ),
        create_point(
            add_arrays(p.position, add_arrays(multiply_by_scalar(t1, 2), t2)),
            divide_by_scalar(t1, 2)
        ),
        create_point(
            add_arrays(p.position, t1),
            divide_by_scalar(negative(t2), 2)
        ),
        create_point(
            add_arrays(p.position, negative(t1)),
            divide_by_scalar(negative(t2), 2)
        ),
        create_point(
            add_arrays(p.position, negative(add_arrays(t2, multiply_by_scalar(t1, 2)))),
            divide_by_scalar(t1, 2)
        ),
        create_point(
            add_arrays(p.position, negative(add_arrays(t1, multiply_by_scalar(t2, 2)))),
            divide_by_scalar(t2, 2)
        ),
        create_point(
            add_arrays(p.position, negative(multiply_by_scalar(t2, 3))),
            divide_by_scalar(t1, 2)
        ),
    ])

"""
class levy_curve:
    def __init__(self, alpha, num):
        self.alpha = alpha
        self.num = num
        return

    def __call__(self, p):
        beta = self.alpha / 2
        k = 2 * tan(beta)
        h = rotate(rot(p), -pi / 2 + beta) * cos(beta) / 2
        for i in range(self.num):
            yield create_point(loc(p) + h, h * k)
            h = rotate(h, self.alpha)

        raise StopIteration
"""
