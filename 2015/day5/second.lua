local nice_count = 0

local input = io.open("input.txt", "r")

for line in input:lines("l") do
    local repeat_group = line:match("(..).*%1")
    local repeat_between = line:match("(.).%1")

    if repeat_group and repeat_between then nice_count = nice_count + 1 end
end

print(("%d strings are nice"):format(nice_count))

input:close()
