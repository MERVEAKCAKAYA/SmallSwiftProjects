//
//  Mission.swift
//  Moonshot
//
//  Created by Merve Akçakaya on 24.04.2026.
//

import Foundation

struct Mission : Codable, Identifiable{
    
    struct CrewRole : Codable{
        let name: String
        let role : String
    }
    
    let id : Int
    let launchDate : Date?
    let crew : [CrewRole]
    let description : String
    
    var displayName : String{
        return "Apollo \(id)"
    }
    
    var image : String{
        return "apollo\(id)"
    }
    
    var formattedLaunchDate : String{
        return launchDate?.formatted(date: .abbreviated, time: .omitted) ?? "N/A"
    }
}
