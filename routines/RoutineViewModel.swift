import SwiftUI
import Foundation

struct Routine: Identifiable {
    let id = UUID()
    var name: String
    var tasks: [Task]

    var totalDurationSecs: UInt {
        tasks.reduce(0) { $0 + $1.durationSecs }
    }
}

struct Task: Identifiable {
    let id = UUID()
    var instruction: String
    var durationSecs: UInt
}

let exampleRoutine = Routine(
    name: "morning routine",
    tasks: [
        Task(instruction: "floss", durationSecs: 180),
        Task(instruction: "brush", durationSecs: 120),
        Task(instruction: "wash face", durationSecs: 60),
        Task(instruction: "lotion", durationSecs: 60),
    ])
