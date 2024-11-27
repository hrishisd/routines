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
    let tasks: [Task]
    @State private var secondsElapsed: Int = 0
    /// The timer needs to be part of the view state so that it can be cancelled in the onDisappear lifecycle function
    @State private var timer: Timer? = nil
    @State private var addedSecondsForTask: [UUID: Int] = [:]

    private let synthesizer = AVSpeechSynthesizer()

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
            HStack {
                Button("+ 30s") {
                    if timer != nil && timer!.isValid {
                        addedSecondsForTask[inProgressTask().task.id]? += 30
                    }
                }
                Button("skip") {
                    secondsElapsed += inProgressTask().remainingSecs
                }
            }
        }
        .padding()
        .onAppear {
            addedSecondsForTask = Dictionary(uniqueKeysWithValues: tasks.map { ($0.id, 0)})
            synthesizer.speak(utterance("Start with \(inProgressTask().task.instruction)"))
            timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
                if secondsElapsed == totalSeconds() {
                    timer.invalidate()
                    synthesizer.speak(
                        utterance(
                            "Good job. You finished"))
                } else {
                    let currentTask = inProgressTask().task
                    secondsElapsed += 1
                    let nextTask = inProgressTask().task
                    if currentTask.id != nextTask.id {
                        synthesizer.speak(
                            utterance(
                                "Move from \(currentTask.instruction) to \(nextTask.instruction)!"))
                    }
                }
            }
        }
        .onDisappear() {
            timer?.invalidate()
            timer = nil
            synthesizer.stopSpeaking(at: .immediate)
        }
    }

    func totalSeconds() -> Int {
        tasks.reduce(0) {
            $0 + $1.durationSecs + addedSecondsForTask[$1.id, default: 0]
        }
    }

    func inProgressTask() -> (task: Task, remainingSecs: Int) {
        var uncountedSeconds = secondsElapsed
        print("uncounted seconds: ", uncountedSeconds)
        for task in tasks {
            let taskTotalSeconds = task.durationSecs + addedSecondsForTask[task.id, default: 0]
            print(task.instruction, task.durationSecs, "total:",taskTotalSeconds)
            if uncountedSeconds < taskTotalSeconds {
                return (task, taskTotalSeconds - uncountedSeconds)
            }
            uncountedSeconds -= taskTotalSeconds
        }
        return (tasks.last.unsafelyUnwrapped, 0)
    }

    func utterance(_ text: String) -> AVSpeechUtterance {
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: lang)
        return utterance
    }
}

@available(iOS 18.0, *)
#Preview {
    TimerView.init(tasks: exampleRoutine.tasks)
}
