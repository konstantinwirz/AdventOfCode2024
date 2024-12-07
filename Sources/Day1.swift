struct Day1: Solution {

    private static func calculateTotalDistance(_ values: [(Int, Int)]) -> Int {
        // get left values and sort them
        let leftValues = values.map { $0.0 }.sorted()
        // get right values and sort them
        let rightValues = values.map { $0.1 }.sorted()
        // now zip them
        return zip(leftValues, rightValues).map { (left, right) in
            abs(left - right)
        }.reduce(0, +)
    }

    private static func calculateSimilarityScore(_ values: [(Int, Int)]) -> Int {
        // iterate over left value
        values.map { $0.0 }.map { leftValue in
            // determine occurernces of left value in right column
            let occurernces = values.map { $0.1 }.count { $0 == leftValue }
            return leftValue * occurernces
        }.reduce(0, +)
    }

    func test() {
        let values = [
            (3, 4),
            (4, 3),
            (2, 5),
            (1, 3),
            (3, 9),
            (3, 3),
        ]

        let totalDistance = Self.calculateTotalDistance(values)
        assert(totalDistance == 11, "expected total distance to be 11, got \(totalDistance)")

        let similarityScore = Self.calculateSimilarityScore(values)
        assert(similarityScore == 31, "expected similarity score to be 31, got \(similarityScore)")
    }

    func run(_ input: String) {
        let values = input.split(separator: Character("\n")).map { line in
            let values = line.split(maxSplits: 1, whereSeparator: { $0.isWhitespace })

            assert(values.count == 2, "unexpected input")

            let leftValue = Int(values[0].trimmingCharacters(in: .whitespaces))!
            let rightValue = Int(values[1].trimmingCharacters(in: .whitespaces))!
            return (leftValue, rightValue)
        }

        let totalDistance = Self.calculateTotalDistance(values)
        print("total distance = \(totalDistance)")

        let similarityScore = Self.calculateSimilarityScore(values)
        print("similarity score = \(similarityScore)")
    }
}
