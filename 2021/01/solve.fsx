open System.IO

let nums =
  File.ReadLines ("input")
  |> Seq.map int

let part1 =
  nums
  |> Seq.windowed 2
  |> Seq.filter (fun e -> Seq.head e < Seq.last e)
  |> Seq.length

printfn "%d" part1

let part2 =
  nums
  |> Seq.windowed 3
  |> Seq.map (fun e -> Seq.sum e)
  |> Seq.windowed 2
  |> Seq.filter (fun e -> Seq.head e < Seq.last e)
  |> Seq.length

printfn "%d" part2
