all: first second

helper:
	moonc -o helper.lua helper.moon

first: helper
	moonc -o first.lua first.moon

second: helper
	moonc -o second.lua second.moon
