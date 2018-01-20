
cdef struct Point:
    float position[2]
    float rotation[2]


cdef Point create_point(float position[2], float rotation[2])

cdef float[2] rotate(float v[2], float angle)
