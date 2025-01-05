use crate::solutions::day25::Day25;
use clap::Parser;
use std::io::{BufRead, BufReader};

mod solutions;

use crate::solutions::solver::Solution;
use crate::solutions::solver::Solver;

#[derive(Parser)]
struct Cli {
    #[arg(required = true)]
    day: u8,
}

const SOLVERS: [fn(Box<dyn BufRead>) -> anyhow::Result<Solution>; 1] = [
    Day25::solve,
];

fn main() -> anyhow::Result<()> {
    // open file
    let f = std::fs::File::open("TestInput/day25.txt")?;
    let solution = SOLVERS[0](Box::new(BufReader::new(f)))?;
    println!("Part1: {}\nPart2: {}\n", solution.part1, solution.part2);
    Ok(())
}
