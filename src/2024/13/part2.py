#!/usr/bin/env python

import sys
import argparse
import re
from itertools import batched
from z3 import *

parser = argparse.ArgumentParser()
parser.add_argument('infile', nargs='?', type=argparse.FileType('r'), default=sys.stdin)
args = parser.parse_args()
input = args.infile.read()
machines = list(batched([int(s) for s in re.findall(r'\d+', input)], 6))

A_COST = 3
B_COST = 1
PART2_DIFF = 10_000_000_000_000

def solve(machine):
    ax, ay, bx, by, gx, gy = machine
    gx += PART2_DIFF
    gy += PART2_DIFF
    a, b = Ints('a b')
    s = Solver()
    s.add(a * ax + b * bx == gx, a * ay + b * by == gy)
    c = s.check()
    if c == unsat:
        return None
    m = s.model()
    return m[a].as_long() * A_COST + m[b].as_long()

part2 = 0

for machine in machines:
    r = solve(machine)
    if r is not None:
        part2 += r

print(part2)
