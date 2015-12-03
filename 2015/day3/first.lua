local input = io.open("input.txt", "r")

local map = {}

local deliveries = 1

local x = 0
local y = 0

map[x] = {}
map[x][y] = true

local function init_pos(x, y)
    if type(map[x]) ~= "table" then map[x] = {} end
end

local char

repeat
    char = input:read(1)

    if char == "^" then
        y = y + 1
    elseif char == "v" then
        y = y - 1
    elseif char == "<" then
        x = x - 1
    elseif char == ">" then
        x = x + 1
    end

    init_pos(x, y)

    if not map[x][y] then
        deliveries = deliveries + 1
        map[x][y] = true
    end
until not char

print("Delivered at least once to " .. deliveries .. " houses")

input:close()
