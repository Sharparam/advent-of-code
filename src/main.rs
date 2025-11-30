use aoc::{cli, registry};

// Import modules to ensure they're compiled and their solutions are registered
#[allow(unused_imports)]
use aoc::y2024;
use clap::Parser;
use std::fs;
use std::path::Path;
use std::time::Instant;

fn main() {
    let cli = cli::Cli::parse();

    match cli.command {
        cli::Commands::Run {
            year,
            day,
            part,
            all,
        } => {
            if all {
                run_all_solutions();
            } else {
                run_solutions(year, day, part);
            }
        }
        cli::Commands::List { year, day } => {
            list_solutions(year, day);
        }
    }
}

fn load_input(year: u32, day: u32) -> Option<String> {
    let input_path = format!("data/aoc/{}/{:02}/input", year, day);

    if Path::new(&input_path).exists() {
        fs::read_to_string(&input_path).ok()
    } else {
        eprintln!("Warning: Input file not found at {}", input_path);
        None
    }
}

fn run_solutions(year: Option<u32>, day: Option<u32>, part: Option<u32>) {
    match (year, day, part) {
        (Some(y), Some(d), Some(p)) => {
            // Run specific solution
            if let Some(solution) = registry::REGISTRY.get_solution(y, d, p) {
                run_single_solution(&solution);
            } else {
                eprintln!("Solution not found for {}/{}/part{}", y, d, p);
            }
        }
        (Some(y), Some(d), None) => {
            // Run all parts for a specific day
            let solutions = registry::REGISTRY.get_day_solutions(y, d);
            if solutions.is_empty() {
                eprintln!("No solutions found for {}/day{}", y, d);
            } else {
                for solution in solutions {
                    run_single_solution(&solution);
                }
            }
        }
        (Some(y), None, None) => {
            // Run all solutions for a year
            let mut solutions = registry::REGISTRY.get_year_solutions(y);
            solutions.sort_by_key(|s| (s.day, s.part));

            if solutions.is_empty() {
                eprintln!("No solutions found for year {}", y);
            } else {
                for solution in solutions {
                    run_single_solution(&solution);
                }
            }
        }
        _ => {
            eprintln!("Invalid combination of arguments. Use --help for usage information.");
        }
    }
}

fn run_all_solutions() {
    let mut solutions = registry::REGISTRY.get_all_solutions();
    solutions.sort_by_key(|s| (s.year, s.day, s.part));

    if solutions.is_empty() {
        eprintln!("No solutions found!");
        return;
    }

    for solution in solutions {
        run_single_solution(&solution);
    }
}

fn run_single_solution(solution: &registry::Solution) {
    println!(
        "\n=== {} Day {} Part {} ===",
        solution.year, solution.day, solution.part
    );

    if let Some(input) = load_input(solution.year, solution.day) {
        let start = Instant::now();
        let result = (solution.function)(&input);
        let duration = start.elapsed();

        println!("Result: {}", result);
        println!("Time: {:?}", duration);
    } else {
        println!("Skipping due to missing input file");
    }
}

fn list_solutions(year: Option<u32>, day: Option<u32>) {
    match (year, day) {
        (Some(y), Some(d)) => {
            let solutions = registry::REGISTRY.get_day_solutions(y, d);
            if solutions.is_empty() {
                println!("No solutions found for {}/day{}", y, d);
            } else {
                println!("Solutions for {}/day{}:", y, d);
                for solution in solutions {
                    println!("  - Part {} ({})", solution.part, solution.name);
                }
            }
        }
        (Some(y), None) => {
            let days = registry::REGISTRY.get_days(y);
            if days.is_empty() {
                println!("No solutions found for year {}", y);
            } else {
                println!("Available days for {}:", y);
                for d in days {
                    let solutions = registry::REGISTRY.get_day_solutions(y, d);
                    let parts: Vec<u32> = solutions.iter().map(|s| s.part).collect();
                    println!("  - Day {} (parts: {:?})", d, parts);
                }
            }
        }
        (None, None) => {
            let years = registry::REGISTRY.get_years();
            if years.is_empty() {
                println!("No solutions found!");
            } else {
                println!("Available years:");
                for y in years {
                    let days = registry::REGISTRY.get_days(y);
                    println!("  - {} ({} days)", y, days.len());
                }
            }
        }
        (None, Some(_)) => {
            eprintln!("Cannot specify day without year");
        }
    }
}
