local grid = require("grid")

grid.init(0)

local ops = {
    ["on"] = function(cell) return cell + 1 end,
    ["off"] = function(cell) return (cell == 0) and 0 or cell - 1 end,
    ["toggle"] = function(cell) return cell + 2 end
}

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

print(("Total brightness: %d"):format(grid.accum(0, function(accum, cell) return accum + cell end)))
