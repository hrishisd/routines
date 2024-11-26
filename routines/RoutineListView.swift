//
//  RoutineListView.swift
//  routines
//
//  Created by Hrishikesh Dharam on 11/23/24.
//

import SwiftUI

struct RoutineListView: View {
    @State var routines: [Routine] = [exampleRoutine]

    var body: some View {
        NavigationView {
            List($routines) { $routine in
                NavigationLink(destination: RoutineView(routine: $routine)) {
                    RoutineRow(routine: $routine)
                }
            }
            .navigationTitle("Routines")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        routines.append(Routine(name: "new routine", tasks: [Task(instruction: "new task", durationSecs: 60)]))
                    }) {
                        Image(systemName: "plus")
                    }
                }
            }
        }
    }
}

public struct RoutineRow: View {
    @Binding var routine: Routine
    @State private var isEditing = false
    @State private var editedName: String = ""

    public var body: some View {
        if isEditing {
            TextField("Routine name", text: $editedName, onCommit: {routine.name = editedName})
            .textFieldStyle(RoundedBorderTextFieldStyle())
        } else {
            Text(routine.name)
                .onTapGesture {
                    editedName = routine.name
                    isEditing = true
                }
        }
    }
}

#Preview {
    RoutineListView()
}
