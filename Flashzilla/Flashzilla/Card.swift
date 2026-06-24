//
//  Card.swift
//  Flashzilla
//
//  Created by Merve Akçakaya on 23.06.2026.
//

import Foundation

struct Card: Codable{
    var prompt : String
    var answer : String
    
    static let example = Card(prompt: "Who is the most beautiful cat in the world", answer: "Bisküvi")
}
