local nice_count = 0

local input = io.open("input.txt", "r")

for line in input:lines("l") do
    local _, vowels = line:gsub("[aeiou]", "%0")
    local repeated = line:match("(.)%1")
    local banned = line:match("ab") or line:match("cd") or line:match("pq") or line:match("xy")

    if vowels >= 3 and repeated and not banned then nice_count = nice_count + 1 end
end

print(("%d strings are nice"):format(nice_count))

input:close()
