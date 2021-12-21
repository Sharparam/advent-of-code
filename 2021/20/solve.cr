#!/usr/bin/env crystal

ALGORITHM = ARGF.read_line.strip.chars.map { |c| c == '#' ? 1 : 0 }
IMAGE = Hash(Tuple(Int32, Int32), Int32).new(0)
ARGF.each_line.skip(1).with_index do |r, y|
  r.strip.chars.each.with_index do |p, x|
    IMAGE[{x, y}] = p == '#' ? 1 : 0
  end
end

SQUARE_DELTAS = [
  {-1, -1}, {0, -1}, {1, -1},
  {-1,  0}, {0,  0}, {1,  0},
  {-1,  1}, {0,  1}, {1,  1}
]

def square_vectors(pos)
  SQUARE_DELTAS.map { |d| {pos[0] + d[0], pos[1] + d[1]} }
end

def read(image, pos)
  square_vectors(pos).map { |p| image[p] }.join.to_i(2)
end

def bounds(image)
  xmin, xmax = image.keys.map { |k| k[0] }.minmax
  ymin, ymax = image.keys.map { |k| k[1] }.minmax
  {xmin, xmax, ymin, ymax}
end

def default(step)
  return 0 unless ALGORITHM[0] == 1
  step.even? ? ALGORITHM[0] : ALGORITHM[-1]
end

def enhance(image, step)
  xmin, xmax, ymin, ymax = bounds(image)
  enhanced = Hash(Tuple(Int32, Int32), Int32).new(default(step))
  (xmin - 1..xmax + 1).each do |x|
    (ymin - 1..ymax + 1).each do |y|
      pos = {x, y}
      enhanced[pos] = ALGORITHM[read(image, pos)]
    end
  end
  enhanced
end

def vis(image)
  xmin, xmax, ymin, ymax = bounds(image)
  (ymin..ymax).each do |y|
    (xmin..xmax).each do |x|
      print image[{x, y}] == 0 ? "  " : "██"
    end
    puts
  end
end

puts 50.times.reduce(IMAGE) { |image, step|
  enhance(image, step).tap { |i| puts i.values.flatten.sum if step == 1 }
}.values.flatten.sum
