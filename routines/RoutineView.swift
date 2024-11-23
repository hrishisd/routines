//
//  RoutineView.swift
//  routines
//
//  Created by Hrishikesh Dharam on 11/23/24.
//

import SwiftUI

struct RoutineView: View {
    let routineId: UUID
    @ObservedObject var viewModel: RoutineViewModel

    var routine: Routine? {
        viewModel.getRoutine(by: routineId)
    }

    var body: some View {
        Group {
            if let routine = routine {
                List {
                    ForEach(routine.tasks) { task in
                        TaskRow(routineId: routineId, task: task, viewModel: viewModel)
                    }
                }
                .navigationTitle(routine.name)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            withAnimation {
                                viewModel.addTask(to: routineId, task: Task(instruction: "new task", durationSecs: 60))
                            }
                        }) {
                            Image(systemName: "plus")
                        }
                    }
                }
            } else {
                // This should never happen
                Text("Routine not found")
            }
        }
    }
}

struct TaskRow: View {
    let routineId: UUID
    let task: Task
    @ObservedObject var viewModel: RoutineViewModel
    @State private var isEditingInstruction = false
    @State private var isEditingDuration = false
    @State private var editedInstruction: String = ""
    @State private var editedDuration: String = ""

    var body: some View {
        VStack(alignment: .leading) {
            if isEditingInstruction {
                TextField("Task instruction", text: $editedInstruction, onCommit: {
                    viewModel.updateTask(routineId: routineId, taskId: task.id, newInstruction: editedInstruction)
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
                        viewModel.updateTask(routineId: routineId, taskId: task.id, newDuration: duration)
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
