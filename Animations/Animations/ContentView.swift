//
//  ContentView.swift
//  Animations
//
//  Created by Merve Akçakaya on 19.04.2026.
//

import SwiftUI

struct ContentView: View {

    let letters = Array("Hello SwiftUI!")
    @State private var animationAmount = 1.0
    @State private var enabled = false
    @State private var dragAmount = CGSize.zero //0,0 başlangıç noktası anlamına gelir
    
    var body: some View {
       /* Button("Tap Me") {
            animationAmount += 1
        }
        .padding(50)
        .background(.red)
        .foregroundStyle(.white)
        .clipShape(Circle())
        .overlay(
            Circle()
                .stroke(.red)
                .scaleEffect(animationAmount)
                .opacity(2 - animationAmount)
                .animation(
                    .easeInOut(duration: 1)
                    .repeatForever(autoreverses: false),
                    value: animationAmount
                )
        )
        .onAppear { animationAmount = 2 }*/
        
        /*
        //yukarıdaki örnekte animation'ı view'a uyguladık. şimdi ise binding'e ekliyoruz.
        //$animationAmount bir binding'tir. buna animation ekleyerek şunu yapıyoruz stepper her tetiklendiğinde animasyonu harekete geçir.
        Stepper("Animasyonu Etkinleştir", value: $animationAmount.animation(
            .easeInOut(duration: 1)
            .repeatCount(3,autoreverses: true)
        ))
        Spacer()
        Circle()
            .frame(width: 25, height: 25)
            .foregroundStyle(.red)
            .scaleEffect(animationAmount)
      */
      /*
        Button("Tap Me"){
            withAnimation(.spring(duration: 1, bounce: 0.5)){
                animationAmount += 360
            }
          }
            .frame(width: 100, height: 100)
            .foregroundStyle(.white)
            .background(.red)
            .clipShape(.circle)
            .rotation3DEffect(.degrees(animationAmount), axis: (x: 0, y: 1, z: 0))
       */
        
        //snake text sürüklenen yazı
        
        HStack(spacing: 4){
            ForEach(0..<letters.count, id:\.self){ num in
                Text(String(letters[num]))
                    .padding(5)
                    .font(.title)
                    .background(enabled ? .blue : .red)
                    .offset(dragAmount)//sürükleme miktarı ne kadar kaydır
                    .animation(.linear.delay(Double(num)/20), value: dragAmount)
            }
        }
        //gesture kullanıcının ekrana dokunarak yaptığı hareketler
        //draggesture sürüklemedir
        .gesture(
            DragGesture()
                .onChanged { value in
                    dragAmount = value.translation // ikisi de CGSize dondurur. Parmak hareketi ile buradaki dragAmount degeri guncellenmiş olur.
                }
                .onEnded{_ in
                    dragAmount = .zero
                    enabled.toggle()
                }
        )
    }

          
 
        
}

#Preview {
    ContentView()
}
