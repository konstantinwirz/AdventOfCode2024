import Foundation

func parseCharacters(_ input: String) -> [[Character]] {
    return input.split(separator: Character("\n")).map { Array($0) }
}

extension Array where Element == [Character] {

    func countWords(_ word: String) -> Int {
        var count = 0
        // looking for the first word character
        for row in 0..<self.count {
            for col in 0..<self[row].count {
                if self[row][col] != word.first! {
                    continue
                }

                // we found the beginning of our word

                // check if the remaining word follows

                if col + word.count <= self[row].count {
                    if String(self[row][col..<col + word.count]) == word {
                        count += 1
                    }
                }

                // check if we have our word backwards
                if col - word.count + 1 >= 0 {
                    if String(self[row][col + 1 - word.count..<col + 1].reversed()) == word {
                        count += 1
                    }
                }

                // now check the upper und upper diagonals

                // up
                if row + 1 - word.count >= 0 {
                    // 0 - left, 1 - straight. 2 - right
                    var foundWords = ["", "", ""]
                    for i in 0..<word.count {
                        foundWords[1].append(self[row - i][col])
                        if col - i >= 0 {
                            foundWords[0].append(self[row - i][col - i])
                        }
                        if col + i < self[row].count {
                            foundWords[2].append(self[row - i][col + i])
                        }
                    }
                    count += foundWords.count { $0 == word }
                }

                // down
                if row + word.count <= self.count {
                    // 0 - left, 1 - straight. 2 - right
                    var foundWords = ["", "", ""]
                    for i in 0..<word.count {
                        foundWords[1].append(self[row + i][col])
                        if col - i >= 0 {
                            foundWords[0].append(self[row + i][col - i])
                        }
                        if col + i < self[row].count {
                            foundWords[2].append(self[row + i][col + i])
                        }
                    }
                    count += foundWords.count { $0 == word }
                }
            }
        }
        return count
    }

    func countXmases() -> Int {
        var count = 0

        for row in 0..<self.count {
            for col in 0..<self[row].count {
                if self[row][col] != "A" {
                    continue
                }

                // we are possibly in middle of MAS cross
                
                if row - 1 >= 0 && row + 1 < self.count && col - 1 >= 0 && col + 1 < self[row].count {
                    // now get the words
                    let words = [
                        String([self[row-1][col-1], self[row][col], self[row+1][col+1]]),
                        String([self[row-1][col+1], self[row][col], self[row+1][col-1]]),
                    ]

                    if words.allSatisfy({ $0 == "MAS" || $0 == "SAM" }) {
                        count += 1
                    }
                }
            }
        }

        return count
    }
}

func test() {
    let input1 = """
        MMMSXXMASM
        MSAMXMSMSA
        AMXSXMAAMM
        MSAMASMSMX
        XMASAMXAMM
        XXAMMXXAMA
        SMSMSASXSS
        SAXAMASAAA
        MAMMMXMMMM
        MXMXAXMASX
        """

    assert(parseCharacters(input1).countWords("XMAS") == 18, "expected word XMAS exactly 18 times")

    let input2 = """
        S..S..S
        .A.A.A.
        ..MMM..
        SAMXMAS
        ..MMM..
        .A.A.A.
        S..S..S
        """

    assert(parseCharacters(input2).countWords("XMAS") == 8, "expected word XMAS exactly 8 times")

    let input3 = """
        .M.S......
        ..A..MSMS.
        .M.S.MAA..
        ..A.ASMSM.
        .M.S.M....
        ..........
        S.S.S.S.S.
        .A.A.A.A..
        M.M.M.M.M.
        ..........
        """

    assert(parseCharacters(input3).countXmases() == 9, "expected XMAS exactly 9 times")
}

func run() {
    let input = try! String(contentsOfFile: "input.txt", encoding: .ascii)

    print("XMAS occurrs \(parseCharacters(input).countWords("XMAS")) times")
    print("crossed MAS/SAM occurrs \(parseCharacters(input).countXmases()) times")
    
}

//test()
run()
