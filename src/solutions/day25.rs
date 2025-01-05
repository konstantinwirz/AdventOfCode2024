use crate::solutions::solver::{Solution, Solver};
use anyhow::bail;
use std::io::BufRead;

pub struct Day25;

impl Solver for Day25 {
    fn solve<R: BufRead>(mut input: R) -> anyhow::Result<Solution> {
        let (locks, keys) = parse_input(input)?;


        Ok(Solution {
            part1: solve_part1(locks, keys).to_string(),
            part2: "B".to_owned(),
        }
        )
    }
}

fn solve_part1(locks: Vec<[u8; 5]>, keys: Vec<[u8; 5]>) -> usize {
    let mut count: usize = 0;
    for lock in &locks {
        for key in &keys {
            let mut fit = true;
            for i in 0..5 {
                if lock[i] + key[i] > 5 {
                    fit = false;
                    break;
                }
            }

            if fit {
                count += 1;
            }
        }
    }

    count
}


fn parse_input<R: BufRead>(mut input: R) -> anyhow::Result<(Vec<[u8; 5]>, Vec<[u8; 5]>)> {
    let mut locks = Vec::<[u8; 5]>::new();
    let mut keys = Vec::<[u8; 5]>::new();

    let mut id_line = String::with_capacity(6);
    loop {
        id_line.clear();
        let bytes_read = input.read_line(&mut id_line)?;
        if bytes_read == 0 {
            break;
        }

        if bytes_read != 6 {
            continue;
        }

        match &id_line[..5] {
            "#####" => {
                locks.push(parse_heights(&mut input)?);
            }
            "....." => {
                keys.push(parse_heights(&mut input)?);
            }
            _ => bail!("Invalid input, expected either LOCK or KEY, got: {}", &id_line),
        }
    }
    
    Ok((locks, keys))
}

fn parse_heights<R: BufRead>(mut input: R) -> anyhow::Result<[u8; 5]> {
    let mut heights = [0; 5];
    // we do expect exactly 6 lines
    let mut line = String::with_capacity(6);
    for i in 0..6 {
        input.read_line(&mut line)?;
        anyhow::ensure!(line.len() == 6, "invalid line length, expected 6 characters, got {}", line.len());

        if i == 5 {
            // consume the line but don't process it
            break;
        }

        for j in 0..heights.len() {
            if let Some(ch) = line.chars().nth(j) {
                if ch == '#' {
                    heights[j] += 1;
                }
            }
        }
        line.clear();
    }

    Ok(heights)
}

#[cfg(test)]
mod test {
    use super::Solver;
    use super::*;

    #[test]
    fn test_part1() -> anyhow::Result<()> {
        let input = r#"#####
.####
.####
.####
.#.#.
.#...
.....

#####
##.##
.#.##
...##
...#.
...#.
.....

.....
#....
#....
#...#
#.#.#
#.###
#####

.....
.....
#.#..
###..
###.#
###.#
#####

.....
.....
.....
#....
#.#..
#.#.#
#####
"#;
        let solution = Day25::solve(input.as_bytes())?;
        assert_eq!(solution.part1, "3");
        Ok(())
    }
}