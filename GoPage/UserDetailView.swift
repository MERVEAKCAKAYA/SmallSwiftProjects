//
//  UserDetailView.swift
//  GoPage
//
//  Created by Merve Akçakaya on 2.06.2026.
//

import SwiftUI

struct UserDetailView: View {
    let user: User

    var body: some View {
        Form {
            Section("Name") {
                Text(user.name.isEmpty ? "No name" : user.name)
            }

            Section("City") {
                Text(user.city.isEmpty ? "No city" : user.city)
            }

            Section("Join Date") {
                Text(user.joinDate.formatted(date: .long, time: .omitted))
            }
        }
        .navigationTitle(user.name.isEmpty ? "User Detail" : user.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    UserDetailView(user:User(name: "merve", city: "istanbul", joinDate: .now))
}
