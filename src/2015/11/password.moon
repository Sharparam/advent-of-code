lower_bound = 'a'\byte!
upper_bound = 'z'\byte!

is_valid = (pw) ->
    -- Check if it contains a forbidden character
    return false if pw\match'i' or pw\match'o' or pw\match'l'

    -- Check for two pairs of different letters
    first_pair = pw\match '((%w)%2)'

    return false unless first_pair

    local second_pair

    for pair in pw\gmatch '((%w)%2)'
        if pair != first_pair
            second_pair = pair
            break

    return false unless second_pair

    -- Check for "increasing straight of at least three letters"
    bytes = [char\byte! for char in pw\gmatch '%w']

    for i = 1, #bytes - 2
        if bytes[i + 1] - bytes[i] == 1 and bytes[i + 2] - bytes[i] == 2
            return true

    return false

get_next = (pw) ->
    index = #pw
    wrapped = true

    while wrapped
        byte = pw\sub(index, index)\byte!
        local new_char

        if byte == upper_bound
            wrapped = true
            new_char = 'a'    
        else
            wrapped = false
            new_char = string.char byte + 1

        pw = pw\sub(1, index - 1) .. new_char .. pw\sub(index + 1)
        index -= 1

    pw

{ :is_valid, :get_next }
