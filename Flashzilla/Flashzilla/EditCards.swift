//
//  EditCards.swift
//  Flashzilla
//
//  Created by Merve Akçakaya on 24.06.2026.
//

import SwiftUI

struct EditCards: View {
    @Environment(\.dismiss) var dissmis
    @State private var cards = [Card]()
    @State private var newPrompt = ""
    @State private var newAnswer = ""
    var body: some View {
        NavigationStack{
            List{
                Section{
                    TextField("Prompt", text: $newPrompt)
                    TextField("Answer", text: $newAnswer)
                    Button("Add Card", action: addCard)
                }
                Section{
                    ForEach(0..<cards.count, id:\.self){index in
                        VStack(alignment:.leading){
                            Text(cards[index].prompt).font(.headline)
                            Text(cards[index].answer).foregroundStyle(.secondary)
                        }
                    }
                    //.onDelete(perform: removeCards)
                }
                
            }
            .navigationTitle("Edit Card")
            .toolbar{
                Button("Done", action: done)
            }
           
        }
    }
    
    func done()
    {
        dissmis()
    }

    
    func saveData(){
        if let data = try? JSONEncoder().encode(cards){
            UserDefaults.standard.set(data, forKey: "Cards")
        }
    }
    
    func addCard(){
        let trimmedPrompt = newPrompt.trimmingCharacters(in: .whitespaces)
        let trimmedAnswer = newAnswer.trimmingCharacters(in: .whitespaces)
        guard trimmedAnswer.isEmpty == false && trimmedPrompt.isEmpty == false else{
            return
        }
        let card = Card(prompt: newPrompt, answer: newAnswer)
        cards.insert(card, at:0)
        saveData()
    }
    func removeCards(at offsets: IndexSet){
        cards.remove(atOffsets: offsets)
        saveData()
    }
}

#Preview {
    EditCards()
}
