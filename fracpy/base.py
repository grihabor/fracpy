class Vector:
    def __init__(self, radius, angle):
        self.r = radius  # radius
        self.a = angle  # angle

    def rotate(self, angle):
        self.a += angle
        return self

    def scale(self, factor):
        self.r *= factor
        return self

class Position:
    def __init__(self, x, y):
        self.x = x
        self.y = y
        