#!/usr/bin/env -S deno run --allow-read

import { cons, sum } from "../../lib/functions.ts";

const nums = Deno.readTextFileSync("input").trim().split("\n").map(Number);
console.log([...cons(nums, 2)].filter(([a, b]) => a < b).length);
console.log(
  [...cons([...cons(nums, 3)].map(sum), 2)].filter(([a, b]) => a < b).length,
);
