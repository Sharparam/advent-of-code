aunts = {}

comparers = setmetatable {
        cats: (aunt, wanted) -> aunt > wanted
        trees: (aunt, wanted) -> aunt > wanted
        pomeranians: (aunt, wanted) -> aunt < wanted
        goldfish: (aunt, wanted) -> aunt < wanted
    }, { __index: -> (aunt, wanted) -> aunt == wanted }

parse = (line) ->
    id = tonumber line\match '^Sue (%d+):'
    aunts[id] = {}

    for item, count in line\gmatch '(%a+): (%d+)'
        aunts[id][item] = tonumber count

is_match = (id, attributes) ->
    for item, count in pairs aunts[id]
        return false unless attributes[item] == count
    true

find_match = (attributes) ->
    for id, aunt in ipairs aunts
        return id if is_match id, attributes
    -1

is_real_match = (id, attributes) ->
    for item, count in pairs aunts[id]
        return false unless comparers[item] count, attributes[item]
    true

find_real_match = (attributes) ->
    for id, aunt in ipairs aunts
        return id if is_real_match id, attributes
    -1

{ :parse, :find_match, :find_real_match }
