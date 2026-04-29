//
//  ContentView.swift
//  Moonshot
//
//  Created by Merve Akçakaya on 21.04.2026.
//

import SwiftUI

struct ContentView: View {
    //astronauts.json dosyasındaki verileri dictionary'e alır.
    let astronauts : [String : Astronaut] = Bundle.main.decode("astronauts.json")
    
    //missions.json dosyasındaki verileri Mission structından oluşmuş arraya doldurur.
    let missions : [Mission] = Bundle.main.decode("missions.json")
    
    //ekrana kolon ekler. ne kadar sığabiliyorsa. min genişlik verir.
    let columns = [
        GridItem(.adaptive(minimum: 150))
    ]
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: columns) {
                    ForEach(missions){mission in
                        NavigationLink{
                            MissionView(mission: mission, astronauts: astronauts)
                        }label:{
                            VStack{
                                Image(mission.image)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 100, height: 100)
                                    .padding()
                                VStack{
                                    Text(mission.displayName)
                                        .font(.headline)
                                        .foregroundStyle(.white)
                                    Text(mission.formattedLaunchDate)
                                        .font(.caption)
                                        .foregroundStyle(.white.opacity(0.5))
                                }
                                .padding(.vertical)
                                .frame(maxWidth: .infinity)
                                .background(.lightBackground)
                            }
                            .clipShape(.rect(cornerRadius: 10))
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(.lightBackground)
                            )
                        }
                    }
                }.padding([.horizontal, .bottom])//horizontal sol + sag bosluk saglar, bottom alttan bosluk saglar
            }.navigationTitle("Moonshot")
                .background(.darkBackground)
                .preferredColorScheme(.dark)
        }
    }
}

#Preview {
    ContentView()
}
