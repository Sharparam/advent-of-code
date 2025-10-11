local input = io.open("input.txt", "r")

local total = 0

local function min(a, b, c)
    local nums = {}

    if a < b then
        nums[#nums + 1] = a
        nums[#nums + 1] = b < c and b or c
    else
        nums[#nums + 1] = b
        nums[#nums + 1] = a < c and a or c
    end

    return unpack(nums)
end

for line in input:lines("l") do
    local l, w, h = line:match("(%d+)x(%d+)x(%d+)")
    l = tonumber(l)
    w = tonumber(w)
    h = tonumber(h)

    total = total + l * w * h

    local a, b = min(l, w, h)
    total = total + 2 * (a + b)
end

print("Total feet of ribbon required: " .. total)

input:close()
