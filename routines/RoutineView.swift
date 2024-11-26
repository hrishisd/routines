//
//  RoutineView.swift
//  routines
//
//  Created by Hrishikesh Dharam on 11/23/24.
//

import SwiftUI

struct RoutineView: View {
    @Binding var routine: Routine

    var body: some View {
//        VStack {
            NavigationView {
                NavigationLink(destination: TimerView(tasks: $routine.tasks)) {
                    Image(systemName: "play")
                    Text("Play")
                }
            }
            .frame(maxHeight: 200)
            Group {
                List($routine.tasks) { $task in
                    TaskRow(task: $task)
                }
                .navigationTitle($routine.name)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            routine.tasks.append(Task(instruction: "new task", durationSecs: 60))
                        }) {
                            Image(systemName: "plus")
                        }
                    }
                }
            }
//        }
    }
}

struct TaskRow: View {
    @Binding var task: Task
    @State private var isEditingInstruction = false
    @State private var isEditingDuration = false
    @State private var editedInstruction: String = ""
    @State private var editedDuration: String = ""

    var body: some View {
        VStack(alignment: .leading) {
            if isEditingInstruction {
                TextField("Task instruction", text: $editedInstruction, onCommit: {
                    task.instruction = editedInstruction
                    isEditingInstruction = false
                })
                .textFieldStyle(RoundedBorderTextFieldStyle())
            } else {
                Text(task.instruction)
                    .onTapGesture {
                        editedInstruction = task.instruction
                        isEditingInstruction = true
                    }
            }

            if isEditingDuration {
                TextField("Duration (seconds)", text: $editedDuration, onCommit: {
                    if let duration = UInt(editedDuration) {
                        task.durationSecs = duration
                    }
                    isEditingDuration = false
                })
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.numberPad)
            } else {
                Text("\(task.durationSecs) seconds")
                    .onTapGesture {
                        editedDuration = String(task.durationSecs)
                        isEditingDuration = true
                    }
            }
        }
        .padding(.vertical, 4)
    }
}

@available(iOS 18.0, *)
#Preview {
    @Previewable @State var routine: Routine = exampleRoutine
    NavigationStack {
        RoutineView(routine: $routine)
    }
}
