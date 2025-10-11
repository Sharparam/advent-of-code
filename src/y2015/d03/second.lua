local input = io.open("input.txt", "r")

local map = {}

local deliveries = 1

local santa_x = 0
local santa_y = 0

local robot_x = 0
local robot_y = 0

local mode = true

local function init_pos(x, y)
    if type(map[x]) ~= "table" then map[x] = {} end
end

local function get_pos()
    if mode then return santa_x, santa_y else return robot_x, robot_y end
end

local function move(dx, dy)
    if mode then
        santa_x = santa_x + dx
        santa_y = santa_y + dy
    else
        robot_x = robot_x + dx
        robot_y = robot_y + dy
    end

    mode = not mode
end

local function deliver()
    local x, y = get_pos()

    init_pos(x, y)

    if not map[x][y] then
        map[x][y] = true
        deliveries = deliveries + 1
    end
end

map[santa_x] = {}
map[santa_x][santa_y] = true

local char

repeat
    char = input:read(1)

    if char == "^" then
        move(0, 1)
    elseif char == "v" then
        move(0, -1)
    elseif char == "<" then
        move(-1, 0)
    elseif char == ">" then
        move(1, 0)
    end

    deliver()
until not char

print("Delivered at least once to " .. deliveries .. " houses")

input:close()
