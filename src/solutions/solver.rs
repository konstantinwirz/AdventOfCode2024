use std::io::BufRead;

#[derive(Debug)]
pub struct Solution {
    pub part1: String,
    pub part2: String,
}

pub trait Solver {
    fn solve<R: BufRead>(input: R) -> anyhow::Result<Solution>;
}
