//
//  ContentView.swift
//  Slzzp
//
//  Created by Parth Antala on 2024-07-06.
//

import SwiftUI
import CoreML

struct ContentView: View {
    
    @State private var sleepAmount: Double = 8.0
    @State private var wakeUp: Date = Date.now
    @State private var coffeAmount: Int = 1
    @State private var alertTitle: String = ""
    @State private var alertMessage: String = ""
    @State private var showingAlert = false
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("when do you want wake up?")
                    .font(.headline)
                
                DatePicker("Please enter a time", selection: $wakeUp, displayedComponents: .hourAndMinute)
                    .labelsHidden()
                
                Text("Desired amount of sleep")
                    .font(.headline)
                
                Stepper("\(sleepAmount.formatted())", value: $sleepAmount, in: 4...12, step: 0.25)
                
                Text("Daily coffee intake")
                    .font(.headline)
                
                
                Stepper("\(coffeAmount) cup(s)", value: $coffeAmount, in: 1...20)
              
            }
            .padding()
            .navigationTitle("Slzzp")
            .toolbar {
                Button("Calculate", action: calculateBedtime)
            }
            .alert(alertTitle, isPresented: $showingAlert) {
                
                Button("OK") {
                    
                }
            } message: {
                Text(alertMessage)
            }
        }
        
    }
    
    func calculateBedtime() {
        do {
            let config = MLModelConfiguration()
            let model = try SleepCalculator(configuration: config)
            
            let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
            let hour = (components.hour ?? 0) * 60 * 60
            let minute = (components.minute ?? 0) * 60
            
            let prediction = try model.prediction(wake: Double(hour + minute), estimatedSleep: sleepAmount, coffee: Double(coffeAmount))
            
            let sleepTime = wakeUp - prediction.actualSleep
            alertTitle = "Your ideal bedtime is..."
            alertMessage = sleepTime.formatted(date: .omitted, time: .shortened)
        } catch {
            alertTitle = "Error"
            alertMessage = "Sorry, there was a problem calculation your bedtime."
        }
        showingAlert = true
    }
}




#Preview {
    ContentView()
}
