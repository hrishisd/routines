//
//  RoutineStore.swift
//  routines
//
//  Created by Hrishikesh Dharam on 11/27/24.
//

import Foundation
import SwiftUI


class RoutineStore: ObservableObject {
    @Published var routines: [Routine] = []

    private static func fileURL() throws -> URL {
        try FileManager.default.url(
            for: .documentDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: false)
        .appendingPathComponent("routines.data")
    }

    func load() {
        do {
            let fileURL = try Self.fileURL()
            guard let data = try? Data(contentsOf: fileURL) else {
                routines = [exampleRoutine]
                return
            }
            let decodedRoutines = try JSONDecoder().decode([Routine].self, from: data)
            self.routines = decodedRoutines
        } catch {
            print("Error loading routines: \(error)")
            routines = [exampleRoutine]
        }
    }

    func save() {
        do {
            let data = try JSONEncoder().encode(routines)
            let outfile = try Self.fileURL()
            try data.write(to: outfile)
        } catch {
            print("Error saving routines: \(error)")
        }
    }
}
