#!/usr/bin/env -S deno run --allow-read

const instructions = Deno.readTextFileSync("input").trim()
  .split("\n").map(
    (l) => l.split(" "),
  ).map(([d, n]) => [d, parseInt(n)] as const);

let position = 0;
let aim = 0;
let depth = 0;

for (const [dir, n] of instructions) {
  switch (dir) {
    case "forward":
      position += n;
      depth += aim * n;
      break;

    case "down":
      aim += n;
      break;

    case "up":
      aim -= n;
      break;
  }
}

console.log(position * aim);
console.log(position * depth);
