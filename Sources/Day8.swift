struct Day8: Solution {

    private func calculateAntiNodeCount(_ input: String) -> Int {
        return calculateAntoNodes(
            input.split(separator: "\n").map(String.init).map(Array.init)
            ).map { $0.count { $0 == "#" } }.reduce(0, +)
    }

    private func calculateAntiNodeCountPart2(_ input: String) -> Int {
        return calculateAntiNodesPart2(
            input.split(separator: "\n").map(String.init).map(Array.init)
        ).map{ $0.count { $0 != "." } }.reduce(0, +)
    }

    private func calculateAntoNodes(_ input: [[Character]]) -> [[Character]] {

        var antiNodeMap = input

        for row in 0..<input.count {
            for column in 0..<input[row].count {
                let ch = input[row][column]
                guard ch.isNumber || ch.isLetter else {
                    continue
                }

                // look for 'partners'
                for partner in findPartners(for: ch, ignore: (row, column), inside: input) {
                    // calculate distance
                    let distance = (row: row - partner.row, column: column - partner.column)
                    // apply distance for anti-node
                    let antiNodePos = (row: row + distance.row, column: column + distance.column)
                    if antiNodePos.row >= 0 && antiNodePos.row < input.count
                        && antiNodePos.column >= 0
                        && antiNodePos.column < input[antiNodePos.row].count
                    {
                        antiNodeMap[antiNodePos.row][antiNodePos.column] = "#"
                    }

                }
            }
        }

        //printMap(antiNodeMap)
        return antiNodeMap
    }

    private func calculateAntiNodesPart2(_ input: [[Character]]) -> [[Character]] {

        var antiNodeMap = input

        for row in 0..<input.count {
            for column in 0..<input[row].count {
                let ch = input[row][column]
                guard ch.isNumber || ch.isLetter else {
                    continue
                }

                // look for 'partners'
                for partner in findPartners(for: ch, ignore: (row, column), inside: input) {
                    // calculate distance
                    let distance = (row: row - partner.row, column: column - partner.column)
                    // apply distance for anti-node
                    var antiNodePos = (row: row, column: column)
                    while true {
                        antiNodePos = (row: antiNodePos.row + distance.row, column: antiNodePos.column + distance.column)
                        if antiNodePos.row >= 0 && antiNodePos.row < input.count
                            && antiNodePos.column >= 0
                            && antiNodePos.column < input[antiNodePos.row].count
                        {
                            antiNodeMap[antiNodePos.row][antiNodePos.column] = "#"
                        } else {
                            break
                        }
                    }
                }
            }
        }

        //printMap(antiNodeMap)
        return antiNodeMap
    }

    private func findPartners(
        for ch: Character, ignore pos: (row: Int, column: Int), inside map: [[Character]]
    ) -> [(row: Int, column: Int)] {
        var result: [(row: Int, column: Int)] = []
        for row in 0..<map.count {
            for column in 0..<map[row].count {
                guard row != pos.row && column != pos.column else {
                    continue
                }

                if map[row][column] == ch {
                    result.append((row, column))
                }
            }
        }

        return result
    }

    private func printMap(_ input: [[Character]]) {
        print(input.map { String($0) }.joined(separator: "\n"))
    }

    func test() {
        let input = """
            ............
            ........0...
            .....0......
            .......0....
            ....0.......
            ......A.....
            ............
            ............
            ........A...
            .........A..
            ............
            ............
            """

        assert(calculateAntiNodeCount(input) == 14, "expected exactly 14 antinodes")
        assert(calculateAntiNodeCountPart2(input) == 34, "expected exactly 34 antinodes")
    }

    func run(_ input: String) {
        print("Antinode locations: \(calculateAntiNodeCount(input))")
         print("Antinode locations (part2): \(calculateAntiNodeCountPart2(input))")
    }

}
