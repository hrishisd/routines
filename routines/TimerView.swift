//
//  TimerView.swift
//  routines
//
//  Created by Hrishikesh Dharam on 11/26/24.
//

import SwiftUI

struct TimerView: View {
    @Binding var tasks: [Task]
    @State private var currentTaskIdx: UInt = 0
    @State private var secondsRemaining: UInt

    init(tasks: Binding<[Task]>) {
        _tasks = tasks
        secondsRemaining = tasks[0].durationSecs.wrappedValue
    }

    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

@available(iOS 18.0, *)
#Preview {
    @Previewable @State var routine: Routine = exampleRoutine
    TimerView.init(tasks: $routine.tasks)
}

