# Make lua files a phony target because
# make doesn't properly track them
.PHONY: %.lua

%.lua: %.moon
	moonc $<
