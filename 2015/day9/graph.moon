nodes = {}

add_node = (name) ->
    return if nodes[name]
    nodes[name] = {}

add_edge = (first, second, cost) ->
    error 'One of the nodes do not exist' unless nodes[first] and nodes[second]
    return if nodes[first][second]
    nodes[first][second] = cost

get_all_except = (except) ->
    if type(except) != 'table'
        except = [except]: true
    result = {}
    for node, _ in pairs nodes
        result[node] = true unless except[node]
    result

is_empty = (tbl) ->
    for node, _ in pairs nodes
        return false if tbl[node]
    true

copy = (tbl) ->
    if type(tbl) != 'table'
        return tbl

    result = {}
    
    for k, v in pairs tbl
        result[k] = copy v

    result

shortest_path = (start, visited = {}, cost = 0) ->
    if not start
        costs = [shortest_path name for name, _ in pairs nodes]
        table.sort costs
        return costs[1]

    visited = [start]: true if is_empty visited

    unvisited = get_all_except visited

    if is_empty unvisited
        return cost

    costs = {}

    for node, _ in pairs unvisited
        v = copy visited
        v[node] = true
        costs[#costs + 1] = shortest_path(node, v, cost + nodes[start][node])

    min = costs[1]
    for i = 2, #costs
        min = costs[i] if costs[i] < min
    min

longest_path = (start, visited = {}, cost = 0) ->
    if not start
        costs = [longest_path name for name, _ in pairs nodes]
        table.sort costs
        return costs[#costs]

    visited = [start]: true if is_empty visited

    unvisited = get_all_except visited

    if is_empty unvisited
        return cost

    costs = {}

    for node, _ in pairs unvisited
        v = copy visited
        v[node] = true
        costs[#costs + 1] = longest_path(node, v, cost + nodes[start][node])

    max = costs[1]
    for i = 2, #costs
        max = costs[i] if costs[i] > max
    max

{
    :add_node
    :add_edge
    :shortest_path
    :longest_path
}
