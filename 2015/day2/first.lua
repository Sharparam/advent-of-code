local input = io.open("input.txt", "r")

local total = 0

local function min(a, b, c)
    if a < b then
        return a < c and a or c
    end
    
    return b < c and b or c
end

for line in input:lines("l") do
    local l, w, h = line:match("(%d+)x(%d+)x(%d+)")
    l = tonumber(l)
    w = tonumber(w)
    h = tonumber(h)

    total = total + 2 * (l * w + w * h + h * l)

    total = total + min(l * w, w * h, h * l)
end

print("Total square feet required: " .. total)

input:close()
