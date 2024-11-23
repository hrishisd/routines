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

class RoutineViewModel: ObservableObject {
    @Published var routines: [Routine] = []

    func addRoutine() {
        routines.append(Routine(name: "new routine", tasks: [Task(instruction: "new task", durationSecs: 60)]))
    }

    func updateRoutineName(routineId: UUID, newName: String) {
        if let index = routines.firstIndex(where: { $0.id == routineId }) {
            routines[index].name = newName
        }
    }

    func addTask(to routineId: UUID, task: Task) {
        if let index = routines.firstIndex(where: { $0.id == routineId }) {
            routines[index].tasks.append(task)
        }
    }

    func updateTask(routineId: UUID, taskId: UUID, newInstruction: String? = nil, newDuration: UInt? = nil) {
        if let routineIndex = routines.firstIndex(where: { $0.id == routineId }),
           let taskIndex = routines[routineIndex].tasks.firstIndex(where: { $0.id == taskId }) {
            if let newInstruction = newInstruction {
                routines[routineIndex].tasks[taskIndex].instruction = newInstruction
            }
            if let newDuration = newDuration {
                routines[routineIndex].tasks[taskIndex].durationSecs = newDuration
            }
        }
    }

    func getRoutine(by id: UUID) -> Routine? {
        routines.first { $0.id == id }
    }
}
