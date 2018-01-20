import numpy as np
from libc.math cimport pi, sqrt
from point cimport create_point, Point, rotate


cdef struct Pair:
    float x
    float y


cdef float[2] multiply_by_scalar(float arr[2], float val):
    cdef float result[2]
    result[0] = arr[0] * val
    result[1] = arr[1] * val
    return result

cdef float[2] divide_by_scalar(float arr[2], float val):
    cdef float result[2]
    result[0] = arr[0] / val
    result[1] = arr[1] / val
    return result

cdef float[2] negative(float arr[2]):
    cdef float result[2]
    result[0] = -arr[0]
    result[1] = -arr[1]
    return result

cdef float[2] add_arrays(float arr1[2], float arr2[2]):
    cdef float result[2]
    result[0] = arr1[0] + arr2[0]
    result[1] = arr1[1] + arr2[1]
    return result



cdef koch_curve(Point p):
    cdef float s = pi / 2
    cdef float k = pi / 3

    cdef float t1[2]
    cdef float t2[2]
    cdef float t3[2]
    cdef float t4[2]

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

cdef sierpinski_triangle(Point p):
    cdef float v1[2]
    cdef float v2[2]
    cdef float v3[2]
    cdef float k = 2 * pi / 3
    v1 = divide_by_scalar(p.rotation, 2)
    v2 = rotate(v1, k)
    v3 = rotate(v1, -k)
    return np.array([
        create_point(add_arrays(p.position, v1), v3),
        create_point(add_arrays(p.position, v2), v1),
        create_point(add_arrays(p.position, v3), v2),
    ])


cdef sierpinski_carpet(Point p):
    cdef float new_rot[2]
    cdef float t1[2]
    cdef float t2[2]
    cdef unsigned int i

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


cdef dragon(Point p):
    cdef:
        float k = sqrt(2) / 2
        float q = - pi / 4

        float t1[2]
        float t2[2]

    t1 = multiply_by_scalar(rotate(p.rotation, q), k)
    t2 = multiply_by_scalar(rotate(p.rotation, 3 * q), k)
    return np.array([
        create_point(add_arrays(p.position, negative(t1)), t1),
        create_point(add_arrays(p.position, t2), t2),
    ])



cdef peano_curve(Point p):
    cdef float t1[2]
    cdef float t2[2]

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


cdef minkowski_curve(Point *p):
    cdef float t1[2]
    cdef float t2[2]

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
