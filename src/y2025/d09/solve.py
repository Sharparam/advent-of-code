#!/usr/bin/env python

from fileinput import input
from itertools import combinations
from shapely import Point, Polygon


def box(a: Point, b: Point) -> Polygon:
    x1, x2 = sorted((a.x, b.x))
    y1, y2 = sorted((a.y, b.y))
    return Polygon(((x1, y1), (x1, y2), (x2, y2), (x2, y1)))


def area(box: Polygon) -> int:
    return int((box.bounds[2] - box.bounds[0] + 1) * (box.bounds[3] - box.bounds[1] + 1))


reds = [Point(*map(int, line.split(","))) for line in input(encoding="utf-8")]
boxes = [box(a, b) for (a, b) in combinations(reds, 2)]
polygon = Polygon(reds)

part1 = 0
part2 = 0

for box in boxes:
    a = area(box)
    if a > part1:
        part1 = a
    if a > part2 and polygon.contains(box):
        part2 = a

print(part1)
print(part2)
