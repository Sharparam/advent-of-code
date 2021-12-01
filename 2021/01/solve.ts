#!/usr/bin/env -S deno run --allow-read

import { cons, sum } from "../../lib/functions.ts";

const nums = Deno.readTextFileSync("input").trim().split("\n").map(Number);

console.log([...cons(nums, 2)].filter(([a, b]) => a < b).length);

const triples = [...cons(nums, 3)].map(sum);
const part2 = [...cons(triples, 2)].filter(([a, b]) => a < b).length;
console.log(part2);
