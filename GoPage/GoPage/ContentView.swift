//
//  ContentView.swift
//  GoPage
//
//  Created by Merve Akçakaya on 2.06.2026.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    
    @Environment(\.modelContext) var modelContext
    @Query(sort: \User.name) var users : [User]
    //navigation destination içerisinde birden fazla ekran olduğu için path'İ Route cinsinden tanımladım.
    @State private var path = [Route]()
    enum Route: Hashable {
        case UserDetail(User)
        case UserEdit(User)
    }
    
    var body: some View {
        NavigationStack(path: $path){
            List(users){user in
                NavigationLink(value:Route.UserDetail(user)){
                    Text(user.name)
                }
            }
            .navigationTitle("Users")
            .navigationDestination(for: Route.self){route in
                switch route {
                case Route.UserEdit(let user):
                    EditUserView(user: user)
                case Route.UserDetail(let user):
                    UserDetailView(user: user)
                }
            }
            .toolbar{
                Button("Add", systemImage: "plus"){
                    let user = User(name: "", city: "", joinDate:.now)
                    modelContext.insert(user)
                    path = [Route.UserEdit(user)]
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
