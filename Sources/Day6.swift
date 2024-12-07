import Foundation


struct Day6: Solution {

    func test() {
        let input = """
            ....#.....
            .........#
            ..........
            ..#.......
            .......#..
            ..........
            .#..^.....
            ........#.
            #.........
            ......#...
            """

        var map = Map(fromString: input)
        print(map)
        while map.step() != nil {
            print()
            print(map)
        }
        print()
        print(map)

        assert(map.visitedCount == 41, "expected 41 visited cells, got \(map.visitedCount)")

        Task {
            let obstactlesCount = await map.findObstactles()
            print("obstucles count = \(obstactlesCount)")
        }
    }

    func run(_ input: String) {
        var map1 = Map(fromString: input)
        while map1.step() != nil {}

        print("Result = \(map1.visitedCount)")
    }

}

enum Direction {
    case up
    case down
    case left
    case right
}

struct Position: Hashable {
    let row: Int
    let column: Int
    let direction: Direction

    init(_ ch: Character, row: Int, column: Int) {
        let direction =
            switch ch {
            case "^": Direction.up
            case "v": Direction.down
            case "<": Direction.left
            case ">": Direction.right
            default: abort()
            }

        self.init(row: row, column: column, direction: direction)
    }

    init(row: Int, column: Int, direction: Direction) {
        self.row = row
        self.column = column
        self.direction = direction
    }

}

struct Map: CustomStringConvertible {

    let rows: Int
    let columns: Int
    var data: [[Character]]

    init(fromString s: String) {
        self.data = s.split(separator: Character("\n")).map { Array($0) }
        self.rows = data.count
        self.columns = data.first!.count
    }

    var description: String {
        self.data.map { String($0) }.joined(separator: "\n")
    }

    func currentPosition() -> Position? {
        for row in 0..<rows {
            for column in 0..<columns {
                if ["^", "v", "<", ">"].contains(self.data[row][column]) {
                    return Position(self.data[row][column], row: row, column: column)
                }
            }
        }

        return nil
    }

    /// makes a step and returns next coordinates if we are still inside the map
    mutating func step() -> (row: Int, column: Int)? {
        if let pos = currentPosition() {
            switch pos.direction {
            case .up:
                if pos.row - 1 < 0 {
                    data[pos.row][pos.column] = "X"
                    return nil
                }

                if data[pos.row - 1][pos.column] != "#" {
                    data[pos.row - 1][pos.column] = "^"
                    data[pos.row][pos.column] = "X"
                } else {
                    data[pos.row][pos.column] = ">"
                }

                return (row: pos.row - 1, column: pos.column)
            case .right:
                if pos.column + 1 >= columns {
                    data[pos.row][pos.column] = "X"
                    return nil
                }

                if data[pos.row][pos.column + 1] != "#" {
                    data[pos.row][pos.column + 1] = ">"
                    data[pos.row][pos.column] = "X"
                } else {
                    data[pos.row][pos.column] = "v"
                }

                return (row: pos.row, column: pos.column + 1)
            case .down:
                if pos.row + 1 >= rows {
                    data[pos.row][pos.column] = "X"
                    return nil
                }

                if data[pos.row + 1][pos.column] != "#" {
                    data[pos.row + 1][pos.column] = "v"
                    data[pos.row][pos.column] = "X"
                } else {
                    data[pos.row][pos.column] = "<"
                }

                return (row: pos.row + 1, column: pos.column)
            case .left:
                if pos.column <= 0 {
                    data[pos.row][pos.column] = "X"
                    return nil
                }

                if data[pos.row][pos.column - 1] != "#" {
                    data[pos.row][pos.column - 1] = "<"
                    data[pos.row][pos.column] = "X"
                } else {
                    data[pos.row][pos.column] = "^"
                }

                return (row: pos.row, column: pos.column - 1)
            }
        }

        return nil
    }

    mutating func findObstactles() async -> Int {
        return 0
    }

    var visitedCount: Int {
        self.data.map { $0.count { $0 == "X" } }.reduce(0, +)
    }

}
