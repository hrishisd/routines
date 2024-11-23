//
//  RoutineListView.swift
//  routines
//
//  Created by Hrishikesh Dharam on 11/23/24.
//

import SwiftUI

struct RoutineListView: View {
    @StateObject private var viewModel = RoutineViewModel()

    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.routines) { routine in
                    NavigationLink(destination: RoutineView(routineId: routine.id, viewModel: viewModel)) {
                        RoutineRow(routine: routine, viewModel: viewModel)
                    }
                }
            }
            .navigationTitle("Routines")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        viewModel.addRoutine()
                    }) {
                        Image(systemName: "plus")
                    }
                }
            }
        }
    }
}

struct RoutineRow: View {
    let routine: Routine
    @ObservedObject var viewModel: RoutineViewModel
    @State private var isEditing = false
    @State private var editedName: String = ""

    var body: some View {
        if isEditing {
            TextField("Routine name", text: $editedName, onCommit: {
                viewModel.updateRoutineName(routineId: routine.id, newName: editedName)
                isEditing = false
            })
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
