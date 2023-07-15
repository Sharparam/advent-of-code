use std::{collections::HashSet, fs};

fn main() {
  let contents = fs::read_to_string("input.txt").expect("Could not read input");
  let freqs: Vec<i32> = contents.lines().map(|l| l.parse::<i32>().unwrap()).collect();
  println!("Part 1: {}", freqs.iter().sum::<i32>());

  let mut multiples: HashSet<i32> = HashSet::new();
  let mut freq = 0;

  for &current in freqs.iter().cycle() {
    freq += current;
    if !multiples.insert(freq) {
      break;
    }
  }

  println!("Part 2: {}", freq);
}
