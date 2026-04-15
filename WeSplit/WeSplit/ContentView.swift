//
//  ContentView.swift
//  WeSplit
//
//  Created by Merve Akçakaya on 9.04.2026.
//

import SwiftUI

struct ContentView: View {
    /*Picker Ornek
    let elemanlar = ["Merve", "Salih", "Ece"]
    @State private var seciliEleman = "Merve"
    var body: some View {
       NavigationStack {
           Form{
               Picker("Elemanı Seçin: ", selection:$seciliEleman){
                   ForEach(elemanlar, id: \.self){
                       Text($0)
                   }
               }
               Section{
                   Text("Seçili Eleman: \(seciliEleman)")
               }
           }
           .navigationTitle("Anasayfa")
           
        }
    }
     */
    @State private var checkAmount = 0.0
    @State private var numberOfPeople = 2
    @State private var tipPercentage = 20
    @FocusState private var isFocused: Bool
    let tipPercentages = [10,15,20,25,0]
    var totalPerPerson: Double{
        let peopleCount = Double(numberOfPeople + 2)
        let tipSelection = Double(tipPercentage)
        
        let tipValue = checkAmount / 100 * tipSelection
        let grandTotal = checkAmount + tipValue
        let amountPerPerson = grandTotal / peopleCount
        return amountPerPerson
    }
    var body: some View {
     NavigationStack{
         Form{
             Section{
                 TextField("Amount", value: $checkAmount, format: .currency(code: "USD")).keyboardType(.decimalPad).focused($isFocused)
                 
                 
                 Picker("Number of People", selection: $numberOfPeople){
                     ForEach(2..<100){
                         Text("\($0) of people")
                     }
                 }
                 .pickerStyle(.navigationLink)//eger form bir navigationstack icerisinde degilse bu link calismaz. Disabled gorunur hatta.
             }
             Section("How much do you want to tip?"){
                 Picker("Tip percentage ", selection: $tipPercentage){
                     ForEach(tipPercentages, id: \.self){
                         //Text($0, format: .percent)
                         //Text("\($0)%")
                         Text(String($0) + "%")
                     }
                 }
                 .pickerStyle(.segmented)
             }
             Section{
                 Text(totalPerPerson, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
             }
         }.navigationTitle("WeSplit")
             .toolbar(){
                 if isFocused{
                     Button("Done"){
                         isFocused = false
                     }
                 }
             }
        }
    }
}

#Preview {
    ContentView()
}
