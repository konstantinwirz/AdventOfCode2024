import Foundation

struct Day7: Solution {

    struct Equation: CustomStringConvertible {
        let result: Int
        let values: [Int]

        var description: String {
            "\(result): \(values)"
        }
    }

    func parseEquations(_ input: String) -> [Equation] {
        input.split(separator: "\n").map { line in
            let resultAndValues = line.split(separator: ":")
            assert(resultAndValues.count == 2, "expected exactly 2 values")

            let result = Int(resultAndValues[0])!
            let values = resultAndValues[1].split(separator: " ").map {
                Int($0.trimmingCharacters(in: .whitespaces))!
            }

            return Equation(result: result, values: values)
        }
    }

    func calculateTotalCalibrationResult(
        _ inputEquations: [Equation], withConcatenation: Bool = false
    ) -> Int {
        var sum = 0

        for eq in inputEquations {
            let results = findOperators(eq.values, withConcatenation: withConcatenation)
            //print(results)
            if results.contains(eq.result) {
                sum += eq.result
            }
        }

        return sum
    }

    func findOperators(_ values: [Int], withConcatenation: Bool = false) -> [Int] {
        if values.count < 2 {
            return []
        }

        let sum = values[0] + values[1]
        let product = values[0] * values[1]
        let concatenated = Int(values[...1].map(String.init).joined())!

        if values.count == 2 {
            return [sum, product] + (withConcatenation ? [concatenated] : [])
        }

        return findOperators([sum] + values[2..<values.count], withConcatenation: withConcatenation)
            + findOperators([product] + values[2..<values.count], withConcatenation: withConcatenation)
            + (withConcatenation
                ? findOperators([concatenated] + values[2..<values.count], withConcatenation: withConcatenation)
                : [])
    }

    func test() {
        let input = """
            190: 10 19
            3267: 81 40 27
            83: 17 5
            156: 15 6
            7290: 6 8 6 15
            161011: 16 10 13
            192: 17 8 14
            21037: 9 7 18 13
            292: 11 6 16 20
            """

        let equations = parseEquations(input)

        assert(
            calculateTotalCalibrationResult(equations) == 3749,
            "expected total calibration result to be 3749")

        assert(
            calculateTotalCalibrationResult(equations, withConcatenation: true) == 11387,
            "expected total calibration result with concatenation to be 11387")
    }

    func run(_ input: String) {
        let equations = parseEquations(input)

        print("Total calibration result = \(calculateTotalCalibrationResult(equations))")
        print("Total calibration result with concatenation = \(calculateTotalCalibrationResult(equations, withConcatenation: true))")
    }
}
