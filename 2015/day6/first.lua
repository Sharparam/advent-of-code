local grid = {}

for x = 0, 999 do
    grid[x] = {}
end

local ops = {
    ["on"] = function() return true end,
    ["off"] = function() return false end,
    ["toggle"] = function(cell) return not cell end
}

local function count()
    local lit = 0

    for x = 0, 999 do
        for y = 0, 999 do
            if grid[x][y] then lit = lit + 1 end
        end
    end

    return lit
end

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
            grid[x][y] = func(grid[x][y])
        end
    end
end

input:close()

print(("%d lights are lit"):format(count()))
