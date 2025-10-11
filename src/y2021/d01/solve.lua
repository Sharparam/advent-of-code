#!/usr/bin/env lua

local nums = {}
for line in io.lines('input') do
  nums[#nums + 1] = tonumber(line)
end

local count = 0
for i = 1, #nums - 1 do
  if nums[i] < nums[i + 1] then
    count = count + 1
  end
end

print(count)

count = 0
for i = 1, #nums - 3 do
  if nums[i] < nums[i + 3] then
    count = count + 1
  end
end

print(count)
