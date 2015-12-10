transform = (str) ->
    result = ''
    counter = 0
    current = nil
    for i = 1, #str
        char = string.sub str, i, i
        current = char unless current
        if char != current
            result ..= tostring(counter) .. current
            counter = 0
            current = char
        counter += 1

    result .. tostring(counter) .. current

{ :transform }
