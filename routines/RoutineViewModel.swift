import SwiftUI
import Foundation

struct Routine: Identifiable, Codable, Equatable {
    var id = UUID()
    var name: String
    var tasks: [Task]


}

struct Task: Identifiable, Codable, Equatable {
    var id = UUID()
    var instruction: String
    var durationSecs: Int
}

let exampleRoutine = Routine(
    name: "morning routine",
    tasks: [
        Task(instruction: "floss", durationSecs: 5),
        Task(instruction: "brush", durationSecs: 5),
        Task(instruction: "wash face", durationSecs: 6),
        Task(instruction: "lotion", durationSecs: 6),
    ])
