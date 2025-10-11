local grid = {}

local _grid = {}

function grid.init(value)
    for x = 0, 999 do
        if type(_grid[x]) ~= "table" then _grid[x] = {} end
        for y = 0, 999 do
            _grid[x][y] = value
        end
    end
end

function grid.apply(func, startx, endx, starty, endy)
    for x = startx, endx do
        for y = starty, endy do
            _grid[x][y] = func(_grid[x][y])
        end
    end
end

function grid.accum(start, func)
    local result = start

    for x = 0, 999 do
        for y = 0, 999 do
            result = func(result, _grid[x][y])
        end
    end

    return result
end

return grid
