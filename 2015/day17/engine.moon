containers = {}

parse = (line) -> containers[#containers + 1] = tonumber line

copy_shallow = (tbl) -> {k, v for k, v in pairs tbl}

combinations = (accum = 0, used = {}, target = 150) ->
    counter = 0

    for i = 1, #containers
        continue if used[i] or accum + containers[i] > target

        used[i] = true

        if accum + containers[i] == target
            counter += 1
        else
            copy = copy_shallow used
            copy[i] = true
            counter += combinations accum + containers[i], copy, target

    counter

counts = (accum = 0, results = {}, depth = 1, used = {}, target = 150) ->
    for i = 1, #containers
        continue if used[i] or accum + containers[i] > target

        used[i] = true

        if accum + containers[i] == target
            results[#results + 1] = depth
        else
            copy = copy_shallow used
            copy[i] = true
            counts accum + containers[i], results, depth + 1, copy, target

    -- Don't bother calculating minimum if we're not the root call
    return unless depth == 1

    min = results[1]
    combination_count = 1
    for i = 2, #results
        if results[i] < min
            min = results[i]
            combination_count = 1
        elseif results[i] == min
            combination_count += 1

    combination_count

get_combinations = (target) ->
    combinations 0, {}, target

get_combinations_minimum = (target) ->
    counts 0, {}, 1, {}, target

{ :parse, :get_combinations, :get_combinations_minimum }
