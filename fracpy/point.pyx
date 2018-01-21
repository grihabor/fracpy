# cython: linetrace=True
# distutils: define_macros=CYTHON_TRACE=1 

from libc.math cimport sin, cos

cdef Point create_point(Pair position, Pair rotation):
    cdef Point p
    p.position = position
    p.rotation = rotation
    return p


cdef Pair rotate(Pair v, float angle):
    cdef Pair result
    result.x = v.x * cos(angle) + v.y * sin(angle)
    result.y = -v.x * sin(angle) + v.y * cos(angle)
    return result

