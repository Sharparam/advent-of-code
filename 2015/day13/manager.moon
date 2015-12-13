people = {}

parse = (line) ->
    name, mod, amount, other = line\match '^(%w+) would (%w+) (%d+) happiness units by sitting next to (%w+)%.$'

    change = (mod == 'gain' and 1 or -1) * amount

    people[name] = {} unless people[name]
    people[name][other] = change

generate_permutations = (list, length) ->
    coroutine.yield list if length == 0

    for i = 1, length
        list[length], list[i] = list[i], list[length]
        generate_permutations list, length - 1
        list[length], list[i] = list[i], list[length]

permutations = (list) ->
    length = table.getn list
    coroutine.wrap -> generate_permutations list, length

get_happiness = (order) ->
    happiness = 0
    for index, person in ipairs order
        happiness += people[person][order[index == 1 and #order or index - 1]]
        happiness += people[person][order[index == #order and 1 or index + 1]]
    happiness

get_max_happiness = ->
    names = [k for k, _ in pairs people]
    values = [get_happiness perm for perm in permutations names]
    max = values[1]
    for i = 2, #values
        max = values[i] if values[i] > max
    max

add_self = ->
    people.__SELF__ = {}
    for name, _ in pairs people
        unless name == '__SELF__'
            people.__SELF__[name] = 0
            people[name].__SELF__ = 0 


{ :parse, :get_max_happiness, :add_self }
