import Foundation


let mulRegex = /mul\((\d+),(\d+)\)/

func calculate(_ input: String) -> Int {
    var lastOffset = String.Index(utf16Offset: 0, in: input)

    return input.matches(of: mulRegex).map { match in
        let matched = input[lastOffset..<match.range.upperBound]        
        let indexOfDonnot = matched.range(of: "don't()")
        let indexOfDo = matched.range(of: "do()")

        if let _ = indexOfDonnot {
            // look if do() cancelled the don't()
            if indexOfDo == .none {
                return 0
            }
        }

        //print("MATCHED = \(matched)")
        
        lastOffset = match.range.upperBound
        return Int(match.1)! * Int(match.2)!
    }.reduce(0, +)
}

func test() {
    let input1 = "xmul(2,4)%&mul[3,7]!@^do_not_mul(5,5)+mul(32,64]then(mul(11,8)mul(8,5))"
    assert(calculate(input1) == 161, "expected 161 as result")

    let input2 = "xmul(2,4)&mul[3,7]!^don't()_mul(5,5)+mul(32,64](mul(11,8)undo()?mul(8,5))"
    assert(calculate(input2) == 48, "expected 48 as result")
}

func run() {
    let content = try! String(contentsOfFile: "input.txt", encoding: .utf8)


    print("Result = \(calculate(content))")
}


//test()
run()
