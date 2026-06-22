//
//  ContentView.swift
//  HotProspects
//
//  Created by Merve Akçakaya on 15.06.2026.
//

import SwiftUI
import UserNotifications

struct ContentView: View {
    var body: some View {
        TabView{
            ProspectsView(filter: .none).tabItem {
                Label("Everyone", systemImage: "person.3")
            }
            ProspectsView(filter: .contacted).tabItem {
                Label("Contacted", systemImage: "checkmark.circle")
            }
            ProspectsView(filter:.uncontacted).tabItem {
                Label("UnContacted", systemImage: "questionmark.diamond")
            }
            MeView().tabItem {
                Label("Me", systemImage: "person.crop.square")
            }
        }
    }
}

#Preview {
    ContentView()
}
