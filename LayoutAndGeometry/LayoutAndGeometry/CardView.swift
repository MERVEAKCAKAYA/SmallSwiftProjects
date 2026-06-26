//
//  CardView.swift
//  LayoutAndGeometry
//
//  Created by Merve Akçakaya on 26.06.2026.
//

import SwiftUI

struct CardView: View {
    let card: Card
    let centerY : CGFloat
    var body: some View {
        GeometryReader{geometry in
            let distance = geometry.frame(in: .global).minY - centerY
            let scale   = max(0.85, 1 - abs(distance) / 1200)
            let opacity = max(0.45, 1 - abs(distance) / 600)
            
            cardContent
                .scaleEffect(scale)
                .opacity(opacity)
        }
        .frame(height: 120)
    }
    private var cardContent : some View {
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(.pink)
                
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(card.baslik).font(.title).bold()
                        Text(card.aciklama).font(.subheadline)
                    }
                    Spacer()
                }
                .padding(20)
                .foregroundStyle(.white)
                Image(systemName: "star.fill")
                                .font(.system(size: 40))
                                .foregroundStyle(.white.opacity(0.18))
                                .offset(x: 70, y: 30)
            }
        }
    
}

