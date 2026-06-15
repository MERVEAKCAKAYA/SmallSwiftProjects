//
//  Result.swift
//  BucketList
//
//  Created by Merve Akçakaya on 15.06.2026.
//

import Foundation

struct WikiResult : Codable {
    let query: Query
}

struct Query: Codable {
    let pages : [Int: Page]
}

struct Page: Codable, Comparable{
    let pageid: Int
    let title: String
    
    /*
     
     "terms": {
            "description": ["Royal residence in London"],
            "label": ["Buckingham Palace"],
            "alias": ["BP", "The Palace"]
        }
     terms bu şekilde yani dictionary arrayinden oluşuyor
     
     */
    //sondaki ? işareti hiç terms gelmeyebilir anlamında konulmuştur.
    let terms: [String: [String]]?
    
    
    /*
     
     terms?                    // terms nil mi? nil ise dur, devam etme
          ["description"]      // "description" key'ini bul → [String] döner
                      ?        // bu dizi nil mi? nil ise dur
                       .first  // dizinin ilk elemanını al → String? döner
                             ?? "No further information"
                               // nil ise bu default değeri kullan
     
     */
    //bu computed property'nin yazılma amacı terms?["description"]?.first ?? "No further information" şu ifadeyi her yerde yazmamak içindi.
    var description: String {
        terms?["description"]?.first ?? "No further information"
    }
    
    static func < (lhs: Page, rhs: Page) -> Bool {
        return lhs.title < rhs.title
    }
}
