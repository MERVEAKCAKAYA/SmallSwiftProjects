//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Merve Akçakaya on 14.04.2026.
//
/*
                     USING THE VSTACK
 VStack = Dikeyde viewlari yerlestirmek icin kullanilir.
 VStack {
     Text("Birinci")
     Text("Ikinci")
     Text("Ucuncu")
 }

 // Gorunum:
 // ┌─────────┐
 // │ Birinci │
 // │ Ikinci  │
 // │ Ucuncu  │
 // └─────────┘
 
 // VStack hizalama
 VStack(alignment: .leading) { }   // Sola
 VStack(alignment: .center) { }    // Ortaya
 VStack(alignment: .trailing) { }  // Saga

 
 */

/*
                     USING THE HSTACK
 HStack = Yatayda viewlari yerlestirmek icin kullanilir.
 HStack {
     Text("Sol")
     Text("Orta")
     Text("Sag")
 }

 // Görünüm:
 // ┌───────────────────┐
 // │ Sol  Orta  Sag    │
 // └───────────────────┘
 
 // HStack hizalama
 HStack(alignment: .top) { }       // Uste
 HStack(alignment: .center) { }    // Ortaya
 HStack(alignment: .bottom) { }    // Alta

 
 */

/*
                     USING THE ZSTACK
 ZStack = Viewlari ust uste yerlestirmek icin kullanilir.
 
 ZStack {
     Color.blue        // Arka plan
     Text("Üstte!")    // On plan
 }

 // Gorunum:
 // ┌─────────────┐
 // │             │
 // │   Ustte!    │  ← Text ustte
 // │             │  ← Color altta
 // └─────────────┘
 
 */

import SwiftUI

struct ContentView: View {
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Spain", "UK", "Ukraine", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    @State private var showingScore = false
    @State private var scoreTitle = ""
    var body: some View {
        ZStack{
            LinearGradient(colors: [.blue, .black], startPoint: .top, endPoint: .bottom).ignoresSafeArea()
            VStack{
                Text("GUESS THE FLAG")
                    .font(.largeTitle.bold())
                    .foregroundStyle(.white)
                Spacer()
                VStack(spacing: 20){
                    VStack(spacing: 15){
                        Text("Tap the flag of").foregroundStyle(.secondary)
                            .font(.subheadline.weight(.heavy))
                        Text(countries[correctAnswer])
                            .font(.largeTitle.weight(.semibold))
                    }
                        ForEach(0..<3){ number in
                            Button{
                                flagTapped(number)
                            }label:{
                                Image(countries[number])
                                    .clipShape(.capsule)
                                    .shadow(radius: 5)
                            }
                        }
                }
                .frame(maxWidth:.infinity)
                .padding(.vertical, 20)
                .background(.regularMaterial)
                .clipShape(.rect(cornerRadius: 20))
                Spacer()
                Spacer()
            
                Spacer()
            }
            .padding()
        }
        .alert(scoreTitle, isPresented: $showingScore){
            Button("Countinue", action: askQuestion)
        }message: {
            Text("Your score is??")
        }
    }
    func flagTapped(_ number: Int){
        if number == correctAnswer{
            scoreTitle = "Correct"
        }else{
            scoreTitle = "Wrong"
        }
        showingScore = true
    }
    
    func askQuestion(){
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }
}

#Preview {
    ContentView()
}
