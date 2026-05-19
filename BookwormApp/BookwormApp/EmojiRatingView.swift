//
//  EmojiRatingView.swift
//  BookwormApp
//
//  Created by Merve Akçakaya on 19.05.2026.
//

import SwiftUI

struct EmojiRatingView: View {
    //başka bir yerden gelen değeri sadece gösterdiği için @binding ya da @state kullanmadık
    let rating : Int
    var body: some View {
        switch rating{
        case 1:
            Text("😡")
        case 2:
            Text("😕")
        case 3:
           Text( "😊")
        case 4:
           Text("😃")
        case 5:
           Text("😀")
        default:
           Text("😍")
        }
    }
}

#Preview {
    EmojiRatingView(rating: 3)
}
