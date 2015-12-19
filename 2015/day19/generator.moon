replacements = {}

sequence = {}

copy = (tbl) ->
    return tbl unless type(tbl) == 'table'
    {k, copy v for k, v in pairs tbl}

parse = (line) ->
    source, replace = line\match '(%a+) => (%a+)'

    if source and replace
        replacements[source] = {} unless replacements[source]
        replacements[source][#replacements[source] + 1] = replace
    elseif line\match '%a+'
        sequence = [element for element in line\gmatch '[A-Z][a-z]?']

count_molecules = ->
    generated = {}
    count = 0
    for source, targets in pairs replacements
        for i = 1, #sequence
            continue unless sequence[i] == source
            for target in *targets
                seq = copy sequence
                seq[i] = target
                str = table.concat seq, ''
                count += 1 unless generated[str]
                generated[str] = true
    count

parse_sequence = (str) ->
    [element for element in str\gmatch '[A-Z][a-z]?']

reformat = (sequence using nil) ->
    new_seq = {}
    for elements in *sequence
        for element in elements\gmatch '[A-Z][a-z]?'
            new_seq[#new_seq + 1] = element
    new_seq

reduce = (current, counter, target, mapping) ->
    --coroutine.yield -1 if counter > 1
    coroutine.yield counter if str == target

    for source, replace in pairs mapping
        --for i = 1, #current
            new, num = current\gsub(source, replace, 1)
            coroutine.yield -1 if num == 0 or #new > #current
            reduce new, counter + 1, target, mapping

get_counts = (current, target, mapping) ->
    coroutine.wrap -> reduce current, 1, target, mapping

get_reverse_mapping = ->
    mapping = {}

    for k, v in pairs replacements
        for key in *v
            mapping[key] = k

    mapping

make_molecule = ->
    reverse = get_reverse_mapping!

    molecule = table.concat sequence, ''

    counts = {}

    for count in get_counts molecule, 'e', reverse
        continue if count == -1
        print count
        counts[#counts + 1] = count

{ :parse, :count_molecules, :make_molecule }
