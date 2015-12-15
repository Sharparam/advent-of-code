ingredients = {}

parse = (line) ->
    name, capacity, durability, flavor, texture, calories = line\match '(%w+): capacity (%-?%d+), durability (%-?%d+), flavor (%-?%d+), texture (%-?%d+), calories (%-?%d+)'
    ingredients[#ingredients + 1] = {
        :name
        capacity: tonumber capacity
        durability: tonumber durability
        flavor: tonumber flavor
        texture: tonumber texture
        calories: tonumber calories
    }

calc = (counts, ignore_calories = false) ->
    capacity = 0
    durability = 0
    flavor = 0
    texture = 0
    calories = 0

    for i, data in ipairs ingredients
        capacity += counts[i] * data.capacity
        durability += counts[i] * data.durability
        flavor += counts[i] * data.flavor
        texture += counts[i] * data.texture
        calories += counts[i] * data.calories unless ignore_calories

    capacity = 0 if capacity < 0
    durability = 0 if durability < 0
    flavor = 0 if flavor < 0
    texture = 0 if texture < 0
    calories = 0 if calories < 0

    score = capacity * durability * flavor * texture
    score *= calories unless ignore_calories
    score

generate = (tbl = {}, i = 1, count = #ingredients, limit = 100, aggregator = 0) ->
    if i == count
        tbl[i] = 100 - aggregator
        coroutine.yield tbl

    for n = 0, limit
        tbl[i] = n
        generate tbl, i + 1, count, limit - n, aggregator + n

combinations = ->
    coroutine.wrap -> generate!

best_score = ->
    max = 0

    for combination in combinations!
        score = calc combination, true
        max = score if score > max

    --for first = 0, 100
    --    for second = 0, 100 - first
    --        for third = 0, 100 - first - second
    --            fourth = 100 - first - second - third
    --            score = calc {first, second, third, fourth}, true
    --            max = score if score > max

    max

{ :parse, :calc, :best_score }
