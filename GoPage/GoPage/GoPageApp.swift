//
//  GoPageApp.swift
//  GoPage
//
//  Created by Merve Akçakaya on 2.06.2026.
//

import SwiftUI
import SwiftData

@main
struct GoPageApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: User.self)
    }
}
