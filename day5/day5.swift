import Foundation

func calculate(updates: [[Int]], rules: [Int: [Int]]) -> Int {
    updates.filter { $0.isInRightOrder(withRules: rules) }.map { $0[$0.count / 2] }.reduce(0, +)
}

extension Array where Element == Int {

    func isInRightOrder(withRules rules: [Int: [Int]]) -> Bool {
        if self.count <= 1 {
            return true
        }

        for i in 1..<self.count {
            if !rules[self[0], default: []].contains(self[i]) {
                return false
            }
        }

        return Array(self[1..<self.count]).isInRightOrder(withRules: rules)
    }

    func putInRightOrder(rules: [Int: [Int]]) -> Self {
        var result = Array(self)

        while result.isNotInRightOrder(withRules: rules) {
            for i in 0..<result.count-1 {
                if !rules[result[i], default: []].contains(result[i+1]) {
                    // no rule found for this element
                    // we are going to swap it based on given rules
                    if let rulesIdx = rules.firstIndex(where: { $0.key == result[i+1] && $0.value.contains(result[i])}) {    
                        if let resultIdx = result.firstIndex(of: rules[rulesIdx].key) {
                            result.swapAt(i, resultIdx)
                        }
                    }
                }
            }
        }

        return result
    }

    func isNotInRightOrder(withRules: [Int: [Int]]) -> Bool {
        !isInRightOrder(withRules: withRules)
    }
}

extension Array where Element == [Int] {
    func filterNotInRightOrdered(rules: [Int: [Int]]) -> [[Int]] {
        self.filter { $0.isNotInRightOrder(withRules: rules) }
    }
}

func parseRules(_ input: String) -> [Int: [Int]] {
    input.split(separator: "\n").map {
        let values = $0.components(separatedBy: "|")
        assert(values.count == 2, "expected exactly two pages")

        let pageLeft = Int(values[0])!
        let pageRight = Int(values[1])!
        return (pageLeft, pageRight)
    }.reduce(into: [:]) { (dict: inout [Int: [Int]], pages: (Int, Int)) in
        dict[pages.0, default: []].append(pages.1)
    }
}

func parseUpdates(_ input: String) -> [[Int]] {
    input.split(separator: "\n").map { $0.components(separatedBy: ",").map { Int($0)! } }
}

func test() {
    let pageOrderingRules = """
        47|53
        97|13
        97|61
        97|47
        75|29
        61|13
        75|53
        29|13
        97|29
        53|29
        61|53
        97|53
        61|29
        47|13
        75|47
        97|75
        47|61
        75|61
        47|29
        75|13
        53|13
        """
    let rules = parseRules(pageOrderingRules)
    assert(rules.count == 6, "expected exactly 6 rules")

    let input1 = """
        75,47,61,53,29
        97,61,53,29,13
        75,29,13
        75,97,47,61,53
        61,13,29
        97,13,75,29,47
        """
    let updates = parseUpdates(input1)
    assert(updates.count == 6, "expected exactly 6 updates")

    assert(calculate(updates: updates, rules: rules) == 143, "expected exactly 143")

    let updatesNotInRightOrder = updates.filterNotInRightOrdered(rules: rules)

    assert(calculate(updates: updatesNotInRightOrder.map { $0.putInRightOrder(rules: rules) }, rules: rules) == 123, "expected exactly 123")
}

func run() {
    let fileContent = try! String(contentsOfFile: "input.txt", encoding: .utf8)
    let components = fileContent.components(separatedBy: "\n\n")

    assert(components.count == 2)

    let rules = parseRules(components[0])
    let updates = parseUpdates(components[1])

    print("Result for updates in order = \(calculate(updates: updates, rules: rules))")
    print("Result for updates not in order = \(calculate(updates: updates.filterNotInRightOrdered(rules: rules).map { $0.putInRightOrder(rules: rules) }, rules: rules))")
}

//test()
run()
