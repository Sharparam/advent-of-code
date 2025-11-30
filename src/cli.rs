use clap::{Parser, Subcommand};

#[derive(Parser)]
#[command(name = "aoc")]
#[command(about = "Advent of Code solution runner")]
pub struct Cli {
    #[command(subcommand)]
    pub command: Commands,
}

#[derive(Subcommand)]
pub enum Commands {
    /// Run AoC solutions
    Run {
        /// Year to run (e.g., 2024)
        #[arg(short, long)]
        year: Option<u32>,

        /// Day to run (1-25)
        #[arg(short, long)]
        day: Option<u32>,

        /// Part to run (1 or 2)
        #[arg(short, long)]
        part: Option<u32>,

        /// Run all solutions
        #[arg(short, long)]
        all: bool,
    },

    /// List available solutions
    List {
        /// Year to list (optional)
        #[arg(short, long)]
        year: Option<u32>,

        /// Day to list (optional, requires year)
        #[arg(short, long)]
        day: Option<u32>,
    },
}
