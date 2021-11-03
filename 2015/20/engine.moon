import floor from math

cache = {}

init_houses = (max, mod = 10, max_deliveries = -1) ->
    cache = {}

    for elf = 1, max
        deliveries = 0
        for house = elf, max, elf
            cache[house] = 0 unless cache[house]
            cache[house] += elf * mod
            deliveries += 1
            break if deliveries >= max_deliveries and max_deliveries != -1

get_lowest = (target, mod = 10, max_per_elf = -1) ->
    max_house = floor target / 10

    init_houses max_house, mod, max_per_elf

    house = 1

    while cache[house] < target do house += 1

    house

{ :get_lowest }
