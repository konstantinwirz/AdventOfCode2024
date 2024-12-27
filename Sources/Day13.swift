struct Day13: Solution {

    func test() {
        let input = """
            Button A: X+94, Y+34
            Button B: X+22, Y+67
            Prize: X=8400, Y=5400

            Button A: X+26, Y+66
            Button B: X+67, Y+21
            Prize: X=12748, Y=12176

            Button A: X+17, Y+86
            Button B: X+84, Y+37
            Prize: X=7870, Y=6450

            Button A: X+69, Y+23
            Button B: X+27, Y+71
            Prize: X=18641, Y=10279
            """

        //print(parse(input))
        let result = foo(aMovement: Movement(x: 94, y: 34), bMovement: Movement(x: 22, y: 67), result: Movement(x: 8400, y: 5400), counter: Counter.zero())

        print(result)

    }

    func run(_ input: String) {
    }

    struct Movement {
        let x, y: Int
    }

    enum Button {
        case a, b
    }

    struct ClawMachine : CustomStringConvertible {
        let a,b,prize: Movement

        var description: String {
            """
            Button A: X+\(a.x), Y+\(a.y)
            Button B: X+\(b.x), Y+\(b.y)
            Prize: X=\(prize.x), Y=\(prize.y)
            """
        }
    }

    struct Counter : CustomStringConvertible{
        let a, b: Int

        static func + (left: Counter, right: Counter) -> Counter {
            return Counter(a: left.a + right.a, b: left.b + right.b)
        }

        static func zero() -> Counter {
            Counter(a: 0, b: 0)
        }

        var description: String {
            "counter { a: \(a), b: \(b)}"
        }
    }

    private func findConfigurations(_ clawMachine: ClawMachine) {

    }

    private func foo(aMovement a: Movement, bMovement b: Movement, result: Movement, counter: Counter) -> Counter {
        if result.x < 0 || result.y < 0 {
            print(result)
            return counter
        }

        if result.x - a.x == 0 && result.y - a.y == 0 {
            return Counter.zero()
        }

        if result.x - b.x == 0 && result.y - b.y == 0 {
            return Counter.zero()
        }

        print("counter = \(counter)")

        return foo(aMovement: a, bMovement: b, result: Movement(x: result.x - a.x, y: result.y - a.y), counter: counter + Counter(a:1, b: 0)) //+ foo(aMovement: a, bMovement: b, result: Movement(x: result.x - b.x, y: result.y - b.y), counter: counter + Counter(a:0, b: 1))
    }

    private func parse(_ input: String) -> [ClawMachine] {
        let clawMachinRegex = /Button A: X\+(\d+), Y\+(\d+)\nButton B: X\+(\d+), Y\+(\d+)\nPrize: X=(\d+), Y=(\d+)/

        return input.split(separator: "\n\n\n").flatMap { 
            $0.matches(of: clawMachinRegex).map { match in
                let a = Movement(x: Int(match.1)!, y: Int(match.2)!)
                let b = Movement(x: Int(match.3)!, y: Int(match.4)!)
                let prize = Movement(x: Int(match.5)!, y: Int(match.6)!)
                return ClawMachine(a: a, b: b, prize: prize)
            }
         }
    }
}
