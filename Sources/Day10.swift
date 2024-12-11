struct Day10: Solution {
    func test() {
        let input = """
            89010123
            78121874
            87430965
            96549874
            45678903
            32019012
            01329801
            10456732
            """

        assert(calculateScore(input) == 36)
        assert(countHikingTrails(input) == 81)
    }

    func run(_ input: String) {
        print("Part 1: Score = \(calculateScore(input))")
        print("Part 2: Rating = \(countHikingTrails(input))")
    }

    func calculateScore(_ input: String) -> Int {
        let map = input.split(separator: "\n").map { $0.map { Int(String($0)) ?? -1 } }
        var score = 0
        for row in 0..<map.count {
            for column in 0..<map[row].count where map[row][column] == 0 {
                score += findReachableTrails(map, startingWith: Pos(row: row, column: column)).count
            }
        }

        return score
    }

    private struct Pos: Hashable {
        let row: Int
        let column: Int

        static let zero = Pos(row: 0, column: 0)
    }

    /// Finds all reachable trails from the given position
    /// returns  a set of positions (for a 9) that are reachable from the given position
    private func findReachableTrails(
        _ input: [[Int]],
        startingWith pos: Pos = Pos.zero
    ) -> Set<Pos> {
        // get valid next positions
        let nextPositions = [
            Pos(row: pos.row - 1, column: pos.column), Pos(row: pos.row + 1, column: pos.column),
            Pos(row: pos.row, column: pos.column - 1), Pos(row: pos.row, column: pos.column + 1),
        ].filter { (nextPos: Pos) in
            nextPos.row >= 0 && nextPos.row < input.count && nextPos.column >= 0
                && nextPos.column < input[nextPos.row].count
        }

        if input[pos.row][pos.column] == 8 {
            return nextPositions.filter {
                input[$0.row][$0.column] == 9
            }.reduce(into: Set<Pos>()) { (acc, nextPos) in
                acc.insert(nextPos)
            }
        }

        return nextPositions.filter { nextPos in
            input[nextPos.row][nextPos.column] - input[pos.row][pos.column] == 1
        }.map { nextPos in
            findReachableTrails(input, startingWith: nextPos)
        }.reduce(into: Set<Pos>()) { (acc, positions: Set<Pos>) in
            positions.forEach { acc.insert($0) }
        }
    }

    private func countHikingTrails(
        _ input: String
    ) -> Int {
        let map = input.split(separator: "\n").map { $0.map { Int(String($0)) ?? -1 } }
        var score = 0
        for row in 0..<map.count {
            for column in 0..<map[row].count where map[row][column] == 0 {
                score += findHikingTrails(map, startingWith: Pos(row: row, column: column))
            }
        }

        return score
    }

    private func findHikingTrails(
        _ input: [[Int]],
        startingWith pos: Pos = Pos.zero
    ) -> Int {
        // get valid next positions
        let nextPositions = [
            Pos(row: pos.row - 1, column: pos.column), Pos(row: pos.row + 1, column: pos.column),
            Pos(row: pos.row, column: pos.column - 1), Pos(row: pos.row, column: pos.column + 1),
        ].filter { (nextPos: Pos) in
            nextPos.row >= 0 && nextPos.row < input.count && nextPos.column >= 0
                && nextPos.column < input[nextPos.row].count
        }

        // possible end of trail
        if input[pos.row][pos.column] == 8 {
            return nextPositions.count {
                input[$0.row][$0.column] == 9
            }
        }

        return nextPositions.filter { nextPos in
            input[nextPos.row][nextPos.column] - input[pos.row][pos.column] == 1
        }.map { nextPos in
            findHikingTrails(input, startingWith: nextPos)
        }.reduce(0, +)
    }

}
