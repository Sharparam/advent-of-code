local input = io.open("input.txt", "r")

local floor = 0

local char

repeat
    char = input:read(1)
    if char == "(" then
        floor = floor + 1
    elseif char == ")" then
        floor = floor - 1
    end
until not char

print("Santa is on floor " .. floor)

input:close()
