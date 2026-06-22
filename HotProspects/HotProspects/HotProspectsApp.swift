//
//  HotProspectsApp.swift
//  HotProspects
//
//  Created by Merve Akçakaya on 15.06.2026.
//

import SwiftUI
import SwiftData

@main
struct HotProspectsApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }.modelContainer(for: Prospect.self)
    }
}
