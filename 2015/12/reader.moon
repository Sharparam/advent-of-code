json = require 'json'

get_sum = (data) ->
    sum = 0
    for k, v in pairs data
        num = tonumber v
        if num
            sum += num
        elseif type(v) == 'table'
            sum += get_sum v
    sum

get_sum_nonred = (data) ->
    sum = 0
    for k, v in pairs data
        k_t = type k
        v_t = type v

        return 0 if k_t == 'string' and v == 'red'

        if v_t == 'number'
            sum += v
        elseif v_t == 'table'
            sum += get_sum_nonred v
    sum

sum = (text) ->
    data = json.decode text
    get_sum data

sum_nonred = (text) ->
    data = json.decode text
    get_sum_nonred data

{ :sum, :sum_nonred }
