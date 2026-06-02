//
//  User.swift
//  GoPage
//
//  Created by Merve Akçakaya on 2.06.2026.
//

import Foundation
import SwiftData

@Model
class User: Identifiable {
    var name:String
    var city:String
    var joinDate:Date
    
    init(name: String, city: String, joinDate: Date) {
        self.name = name
        self.city = city
        self.joinDate = joinDate
    }
}
