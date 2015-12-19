grid = {}

parse = (line using grid) ->
    grid[#grid + 1] = [cell == '#' and true or false for cell in line\gmatch '[#\.]']

set = (row, column, state) ->
    grid[row][column] = state

get_dimensions = ->
    #grid, #grid[1]

copy = (tbl using nil) ->
    return tbl unless type(tbl) == 'table'
    {k, copy v for k, v in pairs tbl}

get_state = (grid, row, column using nil) ->
    return false if row < 1 or row > #grid or column < 1 or column > #grid[1]

    grid[row][column]

next_state = (grid, row, column, stuck_mode = false using nil) ->
    return true if stuck_mode and (
        (row == 1 and column == 1) or
        (row == 1 and column == #grid[1]) or
        (row == #grid and column == 1) or
        (row == #grid and column == #grid[1]))

    on = 0
    off = 0
    current = grid[row][column]

    for r = row - 1, row + 1
        for c = column - 1, column + 1
            continue if r == row and c == column
            state = get_state grid, r, c
            if state then on += 1 else off += 1

    if current then return on == 2 or on == 3 else return on == 3

step = (stuck_mode = false using grid) ->
    -- Create a copy of the grid that we check against
    old = copy grid
    for row = 1, #grid
        for column = 1, #grid[row]
            grid[row][column] = next_state old, row, column, stuck_mode

get_counts = (using grid) ->
    on = 0
    off = 0
    for row = 1, #grid
        for column = 1, #grid[row]
            if grid[row][column] then on += 1 else off += 1

    on, off

{ :parse, :set, :get_dimensions, :step, :get_counts }
