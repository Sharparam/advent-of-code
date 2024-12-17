<Query Kind="Statements">
  <Reference>&lt;UserProfile&gt;\projects\advent-of-code\data\aoc\2024\17\input</Reference>
  <Reference>&lt;UserProfile&gt;\projects\advent-of-code\data\aoc\2024\17\input.dec</Reference>
  <Namespace>System.Globalization</Namespace>
  <AutoDumpHeading>true</AutoDumpHeading>
</Query>

var sw = Stopwatch.StartNew();
var input = File.ReadAllText("input");
var inputTime = sw.ElapsedTicks;
(inputTime * 1000 * 1000 / (double)Stopwatch.Frequency).Dump("IO time (μs)");

sw.Restart();
var numberRegex = new Regex(@"\d+");
var numbers = numberRegex.Matches(input).Select(m => ulong.Parse(m.Value)).ToArray();
var a = numbers[0];
var program = numbers[3..];
var parseTime = sw.ElapsedTicks;
(parseTime * 1000 * 1000 / (double)Stopwatch.Frequency).Dump("Parse time (μs)");

sw.Restart();
var part1 = Run(a);
var part1Str = string.Join(',', part1);
var part1Time = sw.ElapsedTicks;
part1Str.Dump("Part 1");
(part1Time * 1000 * 1000 / (double)Stopwatch.Frequency).Dump("Part 1 (μs)");

var size = program.Length;

sw.Restart();
var part2 = Find(0, 0);
var part2Time = sw.ElapsedTicks;
part2.Dump("Part 2");
(part2Time * 1000 * 1000 / (double)Stopwatch.Frequency).Dump("Part 2 (μs)");

((inputTime + parseTime + part1Time + part2Time) * 1000 * 1000 / (double)Stopwatch.Frequency).Dump("Total (μs)");

// Manually translated program
static List<byte> Run(ulong a)
{
    ulong b;
    ulong c;
    var output = new List<byte>();
    do
    {
        b = (a & 0b111) ^ 1;
        c = a / ((ulong)1 << (byte)b);
        b = (b ^ 0b101) ^ c;
        a = a >> 3;
        output.Add((byte)(b & 0b111));
    } while (a != 0);
    
    return output;
}

ulong? Find(ulong a, int i)
{
    if (i == size)
    {
        return a;
    }

    var target = program[^(i + 1)];
    
    for (ulong x = 0; x < 8; x++)
    {
        var reg_a = (a << 3) | x;
        var result = Run(reg_a);
        
        if (result[0] == target)
        {
            var next = Find(reg_a, i + 1);
            if (next is not null)
            {
                return next;
            }
        }
    }
    
    return null;
}
