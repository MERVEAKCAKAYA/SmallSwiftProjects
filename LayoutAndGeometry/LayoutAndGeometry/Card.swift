//
//  Card.swift
//  LayoutAndGeometry
//
//  Created by Merve Akçakaya on 26.06.2026.
//

import Foundation


struct Card: Identifiable{
    var id: UUID = UUID()
    var baslik: String
    var aciklama: String

    static let example = Card(id: UUID(), baslik: "Başlık", aciklama: "Açıklama")
}
