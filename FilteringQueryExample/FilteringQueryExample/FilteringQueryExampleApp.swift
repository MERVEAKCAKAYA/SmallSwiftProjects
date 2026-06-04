//
//  FilteringQueryExampleApp.swift
//  FilteringQueryExample
//
//  Created by Merve Akçakaya on 4.06.2026.
//

import SwiftUI
import SwiftData
@main
struct FilteringQueryExampleApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: User.self)
    }
}
