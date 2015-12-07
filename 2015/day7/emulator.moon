import band, bnot, bor, rshift, lshift from bit32

ops =
    AND: (a, b) -> band a, b
    OR: (a, b) -> bor a, b
    LSHIFT: (a, b) -> lshift a, b
    RSHIFT: (a, b) -> rshift a, b
    NOT: (a) -> bnot a

circuit = {}

cache = {}

get = (wire using circuit) ->
    return cache[wire] if cache[wire]
    num = tonumber wire
    return num if num
    error "Tried to access invalid wire #{wire}" unless circuit[wire]
    cache[wire] = circuit[wire]!
    cache[wire]

set = (wire, value using circuit, cache) ->
    circuit[wire] = -> value
    cache = {} -- Invalidate the cache

parse = (line using ops, circuit) ->
    dest = line\match ' %-> (%w+)$'

    line = line\match '(.+) %-'

    if line\match '^%w+$'
        source = line\match '^(%w+)$'
        circuit[dest] = -> get source
    elseif line\match '^NOT %w+$'
        source = line\match '^NOT (%w+)$'
        circuit[dest] = -> ops.NOT get source
    elseif line\match '^%w+ [A-Z]+ %w+$'
        lop, op, rop = line\match '^(%w+) ([A-Z]+) (%w+)$'
        circuit[dest] = -> ops[op] get(lop), get(rop)

{ :parse, :get, :set }
