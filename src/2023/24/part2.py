#!/usr/bin/env python

import fileinput
import re
from z3 import *

hailstones = [tuple(map(int, re.split(r"[,@]", line))) for line in fileinput.input(encoding="utf-8")]

rock_x, rock_y, rock_z, rock_vx, rock_vy, rock_vz = Ints('x y z vx vy vz')
rock = (rock_x, rock_y, rock_z, rock_vx, rock_vy, rock_vz)

def pos(data, t):
    x, y, z, vx, vy, vz = data
    return (x + vx  * t, y + vy * t, z + vz * t)

def match(d1, d2, t):
    x1, y1, z1 = pos(d1, t)
    x2, y2, z2 = pos(d2, t)
    return (x1 == x2, y1 == y2, z1 == z2)

solver = Solver()

for i, hailstone in enumerate(hailstones[:3]):
    t = Int(f"t{i}")
    matches = match(rock, hailstone, t)
    for m in matches:
        solver.add(m)

solver.check()

model = solver.model()

print(int(str(model[rock_x])) + int(str(model[rock_y])) + int(str(model[rock_z])))
