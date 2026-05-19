//
//  BookwormAppApp.swift
//  BookwormApp
//
//  Created by Merve Akçakaya on 19.05.2026.
//

import SwiftUI
import SwiftData
@main
struct BookwormAppApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Book.self)
    }
}
