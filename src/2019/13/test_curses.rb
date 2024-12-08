#!/usr/bin/env ruby
# frozen_string_literal: true

require 'curses'

grid = [
  [1, 0, 'A']
]

Curses.init_screen
begin
  Curses.noecho
  Curses.cbreak
  Curses.curs_set 0
  Curses.clear
  Curses.setpos 0, 0
  Curses.addstr 'SCORE: 500'
  grid.each do |(y, x, char)|
    Curses.setpos y, x
    Curses.addch char
  end
  Curses.getch
ensure
  Curses.close_screen
end
