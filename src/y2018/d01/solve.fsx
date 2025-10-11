open System.IO

module Seq = let repeat items = seq { while true do yield! items }

let freqs =
    File.ReadLines ("input.txt")
    |> Seq.map int

printfn "Part 1: %d" (Seq.sum freqs)

let part2 =
    Seq.repeat freqs
    |> Seq.scan (fun (f, seen) d -> f + d, seen |> Set.add f) (0, Set.empty)
    |> Seq.find (fun (f, seen) -> seen |> Set.contains f)
    |> fst

printfn "Part 2: %d" part2
