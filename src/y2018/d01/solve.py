#!/usr/bin/env python

from itertools import cycle


def solve():
    with open("input.txt", "r") as file:
        freqs = [int(line) for line in file]

    print(f"Part 1: {sum(freqs)}")

    multiples = set()
    freq = 0

    for current in cycle(freqs):
        freq += current
        if freq in multiples:
            break

        multiples.add(freq)

    print(f"Part 2: {freq}")


if __name__ == "__main__":
    solve()
