//
//  routinesApp.swift
//  routines
//
//  Created by Hrishikesh Dharam on 11/23/24.
//

import SwiftUI

@main
struct routinesApp: App {
    @StateObject private var store: RoutineStore = RoutineStore()

    var body: some Scene {
        WindowGroup {
            RoutineListView(routines: $store.routines)
                .onAppear {
                    store.load()
                }
                .onChange(of: store.routines) { _ in
                    store.save()
                }
        }
    }
}
