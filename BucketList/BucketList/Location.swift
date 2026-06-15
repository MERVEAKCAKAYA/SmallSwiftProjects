//
//  Location.swift
//  BucketList
//
//  Created by Merve Akçakaya on 9.06.2026.
//
import MapKit
import Foundation

struct Location: Identifiable, Codable, Equatable{
    var id:UUID
    var name:String
    var description:String
    var latitude:Double
    var longitude:Double
    
    var coordinate:CLLocationCoordinate2D{
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    static func == (lhs: Location, rhs: Location) -> Bool {
        lhs.id == rhs.id
    }
    
    //preview icinde kullanılmak uzere yazılmıstır. 
    #if DEBUG
    static let example = Location(id: UUID(), name: "Buckingham Palace", description: "Lit by over 40,00 light installations", latitude: 51.501, longitude: -0.141)
    #endif
    
}
