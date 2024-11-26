//
//  TimerView.swift
//  routines
//
//  Created by Hrishikesh Dharam on 11/26/24.
//

import SwiftUI
import AVFoundation

let lang: String = "en-AU"

struct TimerView: View {
    @Binding var tasks: [Task]
    @State private var secondsElapsed: Int = 0
    private let synthesizer = AVSpeechSynthesizer()

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
            synthesizer.speak(utterance(text: "Start with \(inProgressTask().task.instruction)"))
            Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
                if secondsElapsed == totalSeconds() {
                    synthesizer.speak(
                        utterance(
                            text: "You have finished"))
                    timer.invalidate()
                } else {
                    let currentTask = inProgressTask().task
                    secondsElapsed += 1
                    let nextTask = inProgressTask().task
                    print("updating seconds elapsed")
                    if currentTask.id != nextTask.id {
                        synthesizer.speak(
                            utterance(
                                text: "Move from \(currentTask.instruction) to \(nextTask.instruction)!"))
                    }
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

    func utterance(text: String) -> AVSpeechUtterance {
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: lang)
        return utterance
    }
}

@available(iOS 18.0, *)
#Preview {
    @Previewable @State var routine: Routine = exampleRoutine
    TimerView.init(tasks: $routine.tasks)
}
