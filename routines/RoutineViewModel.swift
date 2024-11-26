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

