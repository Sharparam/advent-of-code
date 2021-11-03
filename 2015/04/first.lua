local engine = require("engine")

local input = "iwrupvqb"

local number = 1

while not engine.test(input, number, "00000") do
    number = number + 1
end

print(number)
