require("md5")

local engine = {}

function engine.test(input, number, expected)
    return md5.sumhexa(input .. number):sub(1, expected:len()) == expected
end

return engine
