local grid = {}

for x = 0, 999 do
    grid[x] = {}
    for y = 0, 999 do
        grid[x][y] = 0
    end
end

local ops = {
    ["on"] = function(cell) return cell + 1 end,
    ["off"] = function(cell) return (cell == 0) and 0 or cell - 1 end,
    ["toggle"] = function(cell) return cell + 2 end
}

local brightness = 0

local input = io.open("input.txt", "r")

for line in input:lines("l") do
    local op, startx, starty, endx, endy = line:match("(%w+) (%d+),(%d+) through (%d+),(%d+)")

    startx = tonumber(startx)
    starty = tonumber(starty)
    endx = tonumber(endx)
    endy = tonumber(endy)

    local func = ops[op]

    for x = startx, endx do
        for y = starty, endy do
            local old = grid[x][y]
            grid[x][y] = func(grid[x][y])
            brightness = brightness + (grid[x][y] - old)
        end
    end
end

input:close()

print(("Total brightness: %d"):format(brightness))
