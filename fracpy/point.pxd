

cdef struct Pair:
    float x
    float y


cdef struct Point:
    Pair position
    Pair rotation


cdef Point create_point(Pair position, Pair rotation)

cdef Pair rotate(Pair v, float angle)
