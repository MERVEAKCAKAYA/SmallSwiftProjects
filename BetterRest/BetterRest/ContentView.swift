//
//  ContentView.swift
//  BetterRest
//
//  Created by Merve Akçakaya on 16.04.2026.
//
import CoreML
import SwiftUI

struct ContentView: View {
    @State private var wakeUp = DefaultWakeTime
    @State private var sleepAmount = 8.0
    @State private var coffeeAmount = 1
    
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var showingAlert = false
    
    static var DefaultWakeTime : Date {
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        return Calendar.current.date(from: components) ?? .now
    }

    var body: some View {
       NavigationStack {
            Form {
                VStack(alignment: .leading,spacing: 5){
                   Text("When do you want to wake up?").font(.headline)
                   DatePicker("", selection: $wakeUp, displayedComponents:.hourAndMinute).labelsHidden()
                }
                VStack(alignment: .leading,spacing: 5){
                    Text("Desire amount of sleep?").font(.headline)
                    Stepper("\(sleepAmount.formatted())", value: $sleepAmount,in: 4...12, step: 0.25)
                }
                VStack(alignment: .leading,spacing: 5){
                    Text("Daily coffee intake?").font(.headline)
                    Stepper("\(coffeeAmount) cup(s)", value: $coffeeAmount, in:1...20, step:1)
                }
            }.navigationTitle("Better Rest")
               .toolbar {
                   Button("Calculate", action: calculateBedTime)
               }
               .alert(alertTitle, isPresented: $showingAlert){
                   Button("OK"){}
               }message: {
                   Text(alertMessage)
               }
        }
    }
    func calculateBedTime() {
        do{
            let config = MLModelConfiguration()
            let model = try BetterRest(configuration: config)
            
            let components =  Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
            let hour = (components.hour ?? 0) * 60 * 60
            let minute = (components.minute ?? 0) * 60
            
            let prediction = try model.prediction(wake: Double(hour + minute),
            estimatedSleep: sleepAmount, coffee: Double(coffeeAmount))
            
            let sleepTime = wakeUp - prediction.actualSleep
            alertTitle = "Your ideal sleep time is..."
            alertMessage = sleepTime.formatted(date: .omitted, time:.shortened)
            
        }catch {
            alertTitle = "Error"
            alertMessage = "Something went wrong. Try again later."
        }
        showingAlert = true
    }
}

#Preview {
    ContentView()
}
