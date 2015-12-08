specials = { '\\\\', '\\"', '\\x%w%w' }

get_code_length = (str) ->
    str\len!

get_mem_length = (str) ->
    str = str\sub 2, str\len! - 1 -- Remove the beginning and ending quote marks
    for pattern in *specials
        str = str\gsub pattern, '.'
    str\len!

get_lengths = (str) ->
    get_code_length(str), get_mem_length str

get_delta = (str) ->
    code_len, mem_len = get_lengths str
    code_len - mem_len

reencode = (str) ->
    '"' .. str\gsub('\\', '\\\\')\gsub('"', '\\"') .. '"'

{
    :get_code_length
    :get_mem_length
    :get_lengths
    :get_delta
    :reencode
}
