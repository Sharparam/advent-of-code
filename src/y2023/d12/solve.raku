#!/usr/bin/env raku

proto count(Str $str, @lens, %cache = %(), Bool $skip = False --> Int) {
  my $key = $str.chars + @lens.elems * 200;
  if %cache{$key}:exists && !$skip {
    return %cache{$key};
  }

  %cache{$key} = {*}
}

multi count("", [], | --> 1) {}
multi count("", @lens, | --> 0) {}
multi count(Str:D $str where { $_.substr(0, 1) eq "#" }, [], | --> 0) {}

multi count(Str:D $str where { $_.substr(0, 1) eq "." }, @lens, %cache = %(), | --> Int) {
  count($str.substr(1..*), @lens, %cache)
}

multi count(Str:D $str where { $_.substr(0, 1) eq "?" }, @lens, %cache = %(), | --> Int) {
  my $rest = $str.substr(1..*);
  my $first = count($rest, @lens, %cache);
  my $second = count("#{$rest}", @lens, %cache, True);
  $first + $second
}

multi count(Str:D $str, @lens, %cache = %(), | --> Int) {
  return 0 if $str.chars < @lens[0];
  return 0 if $str.substr(0..(@lens[0] - 1)).contains: '.';
  return 0 if $str.chars >= @lens[0] && $str.substr(@lens[0], 1) eq "#";

  my $offset = @lens[0] + 1;
  return count("", @lens[1..*], %cache) if $offset - 1 >= $str.chars;
  count($str.substr($offset..*), @lens[1..*], %cache)
}

([Z] $*ARGFILES.lines.race.map({
  my @split = .split(" ");
  my $records = @split[0];
  my @lens = @split[1].split(",")».Int;
  my $records2 = ($records xx 5).join("?");
  my @lens2 = (@lens xx 5).flat;
  [count($records, @lens), count($records2, @lens2)]
}))».sum».say;
