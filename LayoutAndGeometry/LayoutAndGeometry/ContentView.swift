//
//  ContentView.swift
//  LayoutAndGeometry
//
//  Created by Merve Akçakaya on 26.06.2026.
//

import SwiftUI

struct ContentView: View {
    let cards : [Card] = [
        .init(baslik: "Başlık 1", aciklama: "Açıklama 1"),
        .init(baslik: "Başlık 2", aciklama: "Açıklama 2"),
        .init(baslik: "Başlık 3", aciklama: "Açıklama 3"),
        .init(baslik: "Başlık 4", aciklama: "Açıklama 4"),
        .init(baslik: "Başlık 5", aciklama: "Açıklama 5"),
        .init(baslik: "Başlık 6", aciklama: "Açıklama 6"),
        .init(baslik: "Başlık 7", aciklama: "Açıklama 7")
    ]
    var body: some View {
        GeometryReader{ proxy in
            let centerY = proxy.frame(in: .global).midY
            VStack{
                ScrollView {
                    VStack(spacing:20) {
                        ForEach(cards){card in
                            CardView(card: card, centerY: centerY)
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
