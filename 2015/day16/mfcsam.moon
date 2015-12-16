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

is_match = (aunt, attributes, comparer) ->
    for item, count in pairs aunt
        return false unless (comparer or comparers[item]) count, attributes[item]
    true

find_match = (attributes, comparer) ->
    for id, aunt in ipairs aunts
        return id if is_match aunt, attributes, comparer
    -1

{ :parse, :find_match }
