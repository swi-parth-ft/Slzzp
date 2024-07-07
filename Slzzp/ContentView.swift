//
//  ContentView.swift
//  Slzzp
//
//  Created by Parth Antala on 2024-07-06.
//

import SwiftUI
import CoreML
import Sliders

struct ContentView: View {
    
    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.white]
    }
    
    @State private var sleepAmount: Double = 8.0
    @State private var wakeUp: Date = defaultWakeTime
    @State private var coffeAmount: Int = 1
    @State private var alertTitle: String = ""
    @State private var alertMessage: String = ""
    @State private var showingAlert = false
    
    
    
    @State var value = 0.5
    @State var range = 0.2...0.8
    @State var x = 0.5
    @State var y = 0.5
    
    
    static var defaultWakeTime : Date {
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        return Calendar.current.date(from: components) ?? .now
    }
    
    var body: some View {
        
        NavigationStack {
            ZStack {
                Image("backGroundImage")
                    .resizable()
                    .edgesIgnoringSafeArea(.all)
                VStack {
                    Form {
                        
                        
                        Section("when do you want wake up?") {
                            DatePicker("Please enter a time", selection: $wakeUp, displayedComponents: .hourAndMinute)
                                .labelsHidden()
                                .datePickerStyle(.wheel)
                                .colorScheme(.dark)
                        }
                        
                        .listRowBackground(Color.white.opacity(0.5))
                        
                        Section("Desired amount of sleep") {
                            Text("\(sleepAmount.formatted())")
                                .frame(maxWidth: .infinity, alignment: .center)
                                .font(.system(size: 42))
                            ValueSlider(value: $sleepAmount, in: 4...12, step: 0.25)
                                .valueSliderStyle(
                                    HorizontalValueSliderStyle(
                                        track:
                                            HorizontalRangeTrack(
                                                view: Capsule().foregroundColor(.blue)
                                            )
                                            .background(Capsule().foregroundColor(Color.purple.opacity(0.25)))
                                            .frame(height: 8), thumb: Capsule().foregroundColor(.white.opacity(0.7)),thumbSize: CGSize(width: 23, height: 42), options: .defaultOptions
                                    )
                                )
                                .padding()
                        }
                        .listRowBackground(Color.white.opacity(0.5))
                        
                        Section("Daily coffee intake") {
                            // Stepper("^[\(coffeAmount) cup](inflect: true)" , value: $coffeAmount, in: 1...20)
                            
                            HStack {
                                Button(action: {
                                    if coffeAmount > 1 {
                                        coffeAmount -= 1
                                    }
                                }) {
                                    Image(systemName: "minus.circle")
                                        .font(.system(size: 42, weight: .heavy))
                                        .foregroundColor(.brown)
                                        .shadow(radius: 5)
                                }
                                .buttonStyle(BorderlessButtonStyle())
                                TextField("", value: $coffeAmount, format: .number)
                                    .multilineTextAlignment(.center)
                                    .font(.system(size: 30))
                                    .keyboardType(.decimalPad)
                                    .tint(.green)
                                    .padding()
                                
                                Button(action: {
                                    coffeAmount += 1
                                }) {
                                    Image(systemName: "plus.circle")
                                        .font(.system(size: 42, weight: .heavy))
                                        .foregroundColor(.brown)
                                        .shadow(radius: 5)
                                }                  
                                .buttonStyle(BorderlessButtonStyle())
                            }
                            
                            
                        }
                        .listRowBackground(Color.white.opacity(0.5))
                        
                        
                        
                        
                        
                    }
                    .scrollContentBackground(.hidden)
                    .foregroundColor(.white)
                }
                .navigationTitle("Slzzp")
                .toolbar {
                    Button("Calculate", action: calculateBedtime)
                        .buttonStyle()
                }
                .alert(alertTitle, isPresented: $showingAlert) {
                    Button("OK") {}
                } message: {
                    Text(alertMessage)
                }
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


struct ButtonViewModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .buttonStyle(.borderedProminent)
            .tint(.white.opacity(0.4))
            .cornerRadius(20)
            .shadow(radius: 10)
    }
}

extension View {
    func buttonStyle() -> some View {
        modifier(ButtonViewModifier())
    }
}


#Preview {
    ContentView()
}
