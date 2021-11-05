#!/usr/bin/env -S deno run --allow-read

const freqs = Deno.readTextFileSync("input.txt").trim().split("\n").map(Number);
const sum = freqs.reduce((a, e) => a + e);

console.log(`Part 1: ${sum}`);

const multiples = new Set();
let freq = 0;

for (let i = 0;; i = (i + 1) % freqs.length) {
  freq += freqs[i];

  if (multiples.has(freq)) {
    break;
  }

  multiples.add(freq);
}

console.log(`Part 2: ${freq}`);
