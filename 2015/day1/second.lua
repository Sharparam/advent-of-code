local input = io.open("input.txt", "r")

local floor = 0

local char

local position = 0

repeat
    char = input:read(1)
    position = position + 1
    if char == "(" then
        floor = floor + 1
    elseif char == ")" then
        floor = floor - 1
    end
until not char or floor == -1

print("Reached floor -1 at position " .. position)

input:close()
