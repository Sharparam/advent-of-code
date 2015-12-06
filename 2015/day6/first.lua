local grid = require("grid")

grid.init(false)

local ops = {
    ["on"] = function() return true end,
    ["off"] = function() return false end,
    ["toggle"] = function(cell) return not cell end
}

local function count()
    return grid.accum(0, function(accum, cell) return accum + (cell and 1 or 0) end)
end

local input = io.open("input.txt", "r")

for line in input:lines("l") do
    local op, startx, starty, endx, endy = line:match("(%w+) (%d+),(%d+) through (%d+),(%d+)")

    startx = tonumber(startx)
    starty = tonumber(starty)
    endx = tonumber(endx)
    endy = tonumber(endy)

    grid.apply(ops[op], startx, endx, starty, endy)
end

input:close()

print(("%d lights are lit"):format(count()))
