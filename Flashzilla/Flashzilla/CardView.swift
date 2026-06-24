//
//  CardView.swift
//  Flashzilla
//
//  Created by Merve Akçakaya on 23.06.2026.
//

import SwiftUI

struct CardView: View {
    var card : Card
    @State private var showingAnswer = false
    //kartın sürüklenme miktarını bu değerle tutuyoruz.
    @State private var offset = CGSize.zero
    @Environment(\.accessibilityDifferentiateWithoutColor) var accessibilityDifferentiateWithoutColor
    @Environment(\.accessibilityVoiceOverEnabled) var accessibilityVoiceOverEnabled
    
    //removal closure tutan bir değişken.
    //() -> Void) hiçbir değer almayan ve hiçbir şey döndürmeyen fonksiyon
    //? koyduk çünkü bu olabilir de olmayabilir de
    //başlangıçta nil olarak atama yapıyoruz.
    var removal : (() -> Void)? = nil
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 25)
                .fill(
                    accessibilityDifferentiateWithoutColor ?
                        .white :
                        .white.opacity(1 - Double(abs(offset.width / 50)))
                )
                .background(
                    accessibilityDifferentiateWithoutColor
                    ? nil :
                    RoundedRectangle(cornerRadius: 25)
                        .fill(offset.width > 0 ? .green : .red)
                )
                .shadow(radius: 10)
            
            VStack{
                if accessibilityVoiceOverEnabled{
                    Text(showingAnswer ? card.answer : card.prompt)
                        .font(.largeTitle)
                        .foregroundStyle(.black)
                }else{
                    Text(card.prompt)
                        .font(.largeTitle)
                        .foregroundStyle(.black)
                    if showingAnswer{
                        Text(card.answer)
                            .font(.title)
                            .foregroundStyle(.secondary)
                    }
                }
                
                
            }.padding(20)
                .multilineTextAlignment(.center)
        }
        .frame(width: 450, height: 250)
        //rotationEffect kartı döndürür. offset.width parmağın yatay hareketi.
        .rotationEffect(.degrees(offset.width/5.0))
        //kartı yatay olarak hareket ettirir.
        .offset(x:offset.width * 5, y:0)
        //kartı saydamlaştırır. abs kullanılmasının anlamı sağa da sola da giderken saydamlaşsın eksi değer olmasın.
        //kartı 100 puandan fazla kaydırdığımda tamamen görünmez oluyor zaten. silinmiş efekti veriyor.
        .opacity(2 - Double(abs(offset.width / 50)))
        .accessibilityAddTraits(.isButton)
        .gesture(
            DragGesture()
            .onChanged { gesture in
                offset = gesture.translation
                
            }.onEnded{gesture in
                if abs(offset.width)>100{
                    //burada trailing closure'u çağırıyoruz. boş da olabilir 
                    removal?()
                }else{
                    offset = CGSize.zero
                }
            }
        )
        .onTapGesture {
            showingAnswer.toggle()
        }
        .animation(.default, value: offset)
    }
}

#Preview {
    CardView(card: .example)
}
