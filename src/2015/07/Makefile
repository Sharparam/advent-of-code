all: first second

emulator:
	moonc -o emulator.lua emulator.moon

first: emulator
	moonc -o first.lua first.moon

second: emulator
	moonc -o second.lua second.moon
