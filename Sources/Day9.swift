import Foundation

struct Day9: Solution {

    static let emptyBlock = -1

    func transformToDiskBlocks(_ input: String) -> [Int] {
        var result: [Int] = []
        for (n, c) in input.enumerated() {
            assert(c.isNumber, "expected character to be a number, but got '\(c)'")
            let count = Int(String(c))!
            if n % 2 == 0 {
                // file space
                result += Array(repeating: n / 2, count: count)
            } else {
                // free space
                result += Array(repeating: Self.emptyBlock, count: count)
            }
        }

        return result
    }

    // part 1
    func rearrangeDiskBlocks(_ diskBlocks: [Int]) -> [Int] {
        var result: [Int] = diskBlocks
        var rightIndex = diskBlocks.count - 1

        for leftIndex in 0..<diskBlocks.count {
            if diskBlocks[leftIndex] != Self.emptyBlock {
                continue
            }

            assert(diskBlocks[leftIndex] == Self.emptyBlock)

            while diskBlocks[rightIndex] == Self.emptyBlock && rightIndex > leftIndex {
                rightIndex -= 1
            }

            if rightIndex <= leftIndex {
                break
            }

            result[leftIndex] = diskBlocks[rightIndex]
            result[rightIndex] = Self.emptyBlock
            rightIndex -= 1
        }

        return result
    }

    // part 2
    func deframentizeDiskBlock(_ diskBlocks: [Int]) -> [Int] {
        var result = diskBlocks
        var right = diskBlocks.count - 1
        while right > 0 {
            guard let nonFreeBlock = result.nextNonFreeBlock(from: right) else {
                break
            }

            if let freeBlock = result.nextFreeBlock(canFit: nonFreeBlock.count),
                freeBlock.startIndex < right
            {
                // copy non-free block to free block
                // and delete non-free block afterwards
                for (i, value) in nonFreeBlock.enumerated() {
                    result[freeBlock.startIndex + i] = value
                    result[nonFreeBlock.startIndex + i] = Self.emptyBlock
                }
            }

            right = nonFreeBlock.startIndex - 1
        }

        return result
    }

    

    func calculateChecksum(_ diskBlocks: [Int]) -> UInt {
        var result: UInt = 0
        for (index, value) in diskBlocks.enumerated() {
            if value == Self.emptyBlock {
                continue
            }

            result += UInt(value * index)
        }

        return result
    }

    func test() {
        let input = "2333133121414131402"

        // part 1
        let checksum1: UInt = calculateChecksum(
            rearrangeDiskBlocks(
                transformToDiskBlocks(input)
            )
        )

        assert(checksum1 == 1928, "expected checksum to be 1928, but got \(checksum1)")

        // part 2

        let checksum2: UInt = calculateChecksum(
            deframentizeDiskBlock(
                transformToDiskBlocks(input)
            )
        )

        assert(checksum2 == 2858, "expected checksum to be 2858, but got \(checksum2)")
    }

    func run(_ input: String) {
        let checksum1 = calculateChecksum(
            rearrangeDiskBlocks(
                transformToDiskBlocks(input)
            )
        )
        let checksum2: UInt = calculateChecksum(
            deframentizeDiskBlock(
                transformToDiskBlocks(input)
            )
        )

        print("Part1: checksum = \(checksum1)")
        print("Part2: checksum = \(checksum2)")
    }

}


fileprivate extension Array where Element == Int {

        func nextFreeBlock(canFit width: Int, from index: Int = 0) -> ArraySlice<Int>? {
            if index < 0 || index >= count {
                return nil
            }

            var begin = index
            // find the first empty block
            while begin < count && self[begin] != Day9.emptyBlock {
                begin += 1
            }

            // empty block starts with `begin`
            var end = begin
            while end < count && self[end] == Day9.emptyBlock {
                end += 1
            }

            return (begin != end && (end - begin) >= width)
                ? self[begin..<end] : nextFreeBlock(canFit: width, from: end + 1)
        }

        func nextNonFreeBlock(from index: Int) -> ArraySlice<Int>? {
            if index < 0 || index >= count {
                return nil
            }

            var begin = index
            // find first non-empty block
            while begin > 0 && self[begin] == Day9.emptyBlock {
                begin -= 1
            }

            // collect non-empty block
            var end = begin
            while end > 0 && self[end] == self[begin] {
                end -= 1
            }

            return (begin == end) ? nil : self[end + 1...begin]
        }

        var description: String {
            map {
                ($0 == Day9.emptyBlock) ? "." : String($0)
            }.joined()
        }
    }