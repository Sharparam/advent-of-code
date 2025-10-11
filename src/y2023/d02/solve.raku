#!/usr/bin/env raku

grammar Games {
    token TOP { <game>+ %% \n }
    token game { Game <.ws> <id=.num> ':' <.ws> <bag>+ % [';' <.ws>] }
    token bag { <item>+ % [',' <.ws>] }
    token item { <count=.num> <.ws> <color> }
    token num { \d+ }
    token color { red | green | blue }
}

class GamesActions {
  method TOP($/) {
    make $<game>.map(*.made)
  }

  method game($/) {
    my @bags = $<bag>.map(*.made);
    my %mins is default(0);
    make %( id => $<id>.made, bags => @bags, mins => %mins )
  }

  method bag($/) {
    my %items is default(0) = $<item>.map({ $_<color>.made => $_<count>.made });
    make %items
  }

  method item($/) {
    make %( count => $<count>.made, color => $<color>.made )
  }

  method num($/) {
    make +$/
  }

  method color($/) {
    make ~$/
  }
}

my $input = $*ARGFILES.slurp;
my @games = Games.parse($input, actions => GamesActions.new).made;

my $part1 = [+] @games.map: -> %game {
  my $valid = True;

  for @(%game<bags>) -> %bag {
    $valid = False if %bag<red> > 12 || %bag<green> > 13 || %bag<blue> > 14;
    for %bag.kv -> $c, $n {
      %game<mins>{$c} = $n if $n > %game<mins>{$c};
    }
  }

  %game<power> = [*] %game<mins>.values;
  $valid ?? %game<id> !! 0
};

say $part1;
say [+] @games.map({ $_<power> });
