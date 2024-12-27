struct Day11: Solution {

    struct Key : Hashable {
        let count: UInt
        let times: UInt
    }

    func test() {
        let input = "125 17"
        assert(blink(input, times: 25) == 55312, "expected exatly 55312 stones")
    }

    func run(_ input: String) {
        print("Part 1: \(blink(input, times: 25)) stones")
        print("Part 2: \(blink(input, times: 75)) stones")
    }

    private func blink(_ input: String, times: UInt = 1) -> UInt {
        let stones = input.split(separator: " ").map { UInt($0)! }
        var count: UInt = 0
        var cache: [Key: UInt] = [:]

        for stone in stones {
            count += blink(stone, times: times, cache: &cache)
        }
        
        return count
    }

    private func blink(_ value: UInt, times: UInt, cache: inout [Key: UInt]) -> UInt {
        if times == 0 {
            return 1
        }

        var count: UInt = 0
        for transformedStone in transformStone(value) {
            let key = Key(count: transformedStone, times: times - 1)
            if let cached = cache[key] {
                count += cached
                continue
            }

            let toBeCached = blink(transformedStone, times: times - 1, cache: &cache)
            cache[key] = toBeCached
            count += toBeCached
        } 

        return count
    }

    private func transformStone(_ value: UInt) -> [UInt] {
        if value == 0 {
            return [1]
        }

        let valueAsString = String(value)
        if valueAsString.count % 2 == 0 {
            return [
                UInt(valueAsString.prefix(valueAsString.count / 2))!,
                UInt(valueAsString.suffix(Int(valueAsString.count / 2)))!,
            ]
        }

        return [value * 2024]
    }

}
