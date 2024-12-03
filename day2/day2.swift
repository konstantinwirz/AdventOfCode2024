import Foundation

enum Sorting {
    case increasing
    case decreasing
}

func isDifferenceAcceptable(left: Int, right: Int) -> Bool {
    let diff = abs(left - right)
    return diff <= 3 && diff > 0
}

extension Array {
    func removing(at index: Int) -> [Element] {
        Array(self[..<index] + self[(index + 1)...])
    }
}

func isSafe(_ values: [Int]) -> Bool {
    if values.count <= 1 {
        return true
    }

    var sorting = Sorting.increasing
    for idx in values.indices {
        // ignore first element
        if idx == 0 {
            continue
        }

        guard isDifferenceAcceptable(left: values[idx], right: values[idx - 1]) else {
            return false
        }

        if idx == 1 {
            assert(values[idx] != values[idx - 1], "must not be same")

            if values[idx] < values[idx - 1] {
                sorting = .decreasing
            } else {
                sorting = .increasing
            }
        } else {
            switch sorting {
            case .increasing:
                if values[idx] < values[idx - 1] {
                    return false
                }
            case .decreasing:
                if values[idx] > values[idx - 1] {
                    return false
                }
            }
        }
    }

    return true
}

func isSafeWithTolerations(_ values: [Int]) -> Bool {
    return isSafe(values) || values.indices.contains { isSafe(values.removing(at: $0)) }
}

func evaluateSafeReports(_ reports: [[Int]]) -> Int {
    reports.count { isSafe($0) }
}

func evaluateSafeReportsWithToleration(_ reports: [[Int]]) -> Int {
    reports.count { isSafeWithTolerations($0) }
}

func test() {
    let reports = [
        [7, 6, 4, 2, 1],
        [1, 2, 7, 8, 9],
        [9, 7, 6, 2, 1],
        [1, 3, 2, 4, 5],
        [8, 6, 4, 4, 1],
        [1, 3, 6, 7, 9],
    ]

    func assertSafe(indices: Int...) {
        for idx in indices {
            assert(isSafe(reports[idx]), "expected \(reports[idx]) to be safe")
        }
    }

    func assertUnsafe(indices: Int...) {
        for idx in indices {
            assert(!isSafe(reports[idx]), "expected \(reports[idx]) to be unsafe")
        }
    }

    assertSafe(indices: 0, 5)
    assertUnsafe(indices: 1, 2, 3, 4)

    assert(evaluateSafeReports(reports) == 2, "expected 2 safe reports")

    // now test the ignoreLevels
    func assertSafeWithTolerations(indices: Int...) {
        for idx in indices {
            assert(
                isSafeWithTolerations(reports[idx]),
                "expected \(reports[idx]) to be safe")
        }
    }

    func assertUnsafeWithTolerations(indices: Int...) {
        for idx in indices {
            assert(
                !isSafeWithTolerations(reports[idx]),
                "expected \(reports[idx]) to be unsafe")
        }
    }

    assertSafeWithTolerations(indices: 0, 3, 4, 5)
    assertUnsafeWithTolerations(indices: 1, 2)

    assert(evaluateSafeReportsWithToleration(reports) == 4, "expected 4 safe reports")

    let additionalReports = [
        [48, 46, 47, 49, 51, 54, 56],
        [1, 1, 2, 3, 4, 5],
        [1, 2, 3, 4, 5, 5],
        [5, 1, 2, 3, 4, 5],
        [1, 4, 3, 2, 1],
        [1, 6, 7, 8, 9],
        [1, 2, 3, 4, 3],
        [9, 8, 7, 6, 7],
    ]

    assert(
        isSafeWithTolerations(additionalReports[0]), "expected \(additionalReports[0]) to be safe")
    assert(
        evaluateSafeReportsWithToleration(additionalReports) == additionalReports.count,
        "expected all reports to be safe")
}

func main() {
    let input = try! String(contentsOfFile: "input.txt", encoding: .ascii)

    let reports = input.split { $0 == "\n" }

    let safeReportCount = reports.map { report in
        report.split { $0.isWhitespace }.map { s in
            Int(s.trimmingCharacters(in: CharacterSet.whitespaces))!
        }
    }.count { isSafe($0) }

    let safeReportWithTolerationsCount = reports.map { report in
        report.split { $0.isWhitespace }.map { s in
            Int(s.trimmingCharacters(in: CharacterSet.whitespaces))!
        }
    }.count { isSafeWithTolerations($0) }

    print("Safe reports: \(safeReportCount)")
    print("Safe reports with tolerations: \(safeReportWithTolerationsCount)")
}

//test()
main()
