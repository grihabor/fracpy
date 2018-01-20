from libc.math cimport sin, cos

cdef create_point(float position[2], float rotation[2]):
    cdef Point p
    p.position = position
    p.rotation = rotation
    return p


cdef float[2] rotate(float v[2], float angle):
    cdef float result[2]
    result[0] = v[0] * cos(angle) + v[1] * sin(angle)
    result[1] = -v[0] * sin(angle) + v[1] * cos(angle)
    return result

