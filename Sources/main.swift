import ArgumentParser
import Foundation

struct RuntimeError: Error, CustomStringConvertible {
    var description: String

    init(_ description: String) {
        self.description = description
    }
}

struct AdventOfCode: ParsableCommand {

    @Flag(name: .shortAndLong, help: "Run tests")
    var test = false

    @Option(name: .shortAndLong, help: "Day to run")
    var day: Int

    private static let solutions: [any Solution] = [
        Day1(), Day2(), Day3(), Day4(), Day5(), Day6(), Day7(), Day8(), Day9(), Day10(), Day11(), Day12(), Day13()
    ]

    func run() throws {
        guard day > 0 && day <= Self.solutions.count else {
            throw RuntimeError("valid day range is 1-\(Self.solutions.count)")
        }

        let solution = Self.solutions[day - 1]
        if test {
            solution.test()
        } else {
            // read input file
            let input = try String(
                contentsOfFile: String(format: "TestInput/day%d.txt", day), encoding: .utf8)
            solution.run(input)
        }
    }
}

AdventOfCode.main()
