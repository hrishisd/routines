//
//  TimerView.swift
//  routines
//
//  Created by Hrishikesh Dharam on 11/26/24.
//

import SwiftUI

struct TimerView: View {
    @Binding var tasks: [Task]
    @State private var secondsElapsed: Int = 0

    var timer: Timer?

    init(tasks: Binding<[Task]>) {
        _tasks = tasks
    }

    var body: some View {
        VStack {
            HStack {
                Text("finished \(secondsElapsed) out of \(totalSeconds()) seconds")
            }
            Circle()
                .strokeBorder(lineWidth: 24)
                .overlay {
                    VStack{
                        Text(inProgressTask().task.instruction)
                            .font(.title)
                        Text("\(inProgressTask().remainingSecs) seconds left")
                    }
                }
        }
        .onAppear {
            Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
                if secondsElapsed == totalSeconds() {
                    timer.invalidate()
                } else {
                    secondsElapsed += 1
                }
            }
        }
    }

    func totalSeconds() -> UInt {
        tasks.reduce(0) {
            $0 + $1.durationSecs
        }
    }

    func inProgressTask() -> (task: Task, remainingSecs: UInt) {
        var uncountedSeconds = secondsElapsed
        for task in tasks {
            if uncountedSeconds <= task.durationSecs {
                return (task, task.durationSecs - UInt(uncountedSeconds))
            }
            uncountedSeconds -= Int(task.durationSecs)
        }
        return (tasks.last.unsafelyUnwrapped, 0)
    }
}

@available(iOS 18.0, *)
#Preview {
    @Previewable @State var routine: Routine = exampleRoutine
    TimerView.init(tasks: $routine.tasks)
}
