local freqs = {}
local part1 = 0

for line in io.lines('input.txt') do
    local freq = tonumber(line)
    freqs[#freqs + 1] = freq
    part1 = part1 + freq
end

print('Part 1: ' .. part1)

local occurrences = setmetatable({}, { __index = function() return 0 end })
occurrences[0] = 1
local current = 0
local ind = 1
local found = nil

while not found do
    current = current + freqs[ind]
    occurrences[current] = occurrences[current] + 1

    if occurrences[current] > 1 then
        found = current
    end

    ind = ind + 1
    if ind > #freqs then ind = 1 end
end

print('Part 2: ' .. found)
