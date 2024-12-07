/// Represents a solution for a partucular day
protocol Solution : Sendable {
    func test()
    func run(_ input: String)
}
