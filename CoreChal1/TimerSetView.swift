//
//  TimerSetView.swift
//  CoreChal1
//
//  Created by Hendrik Nicolas Carlo on 24/03/25.
//

import SwiftUI

struct TimerSetView: View {
    @State private var hours: Int = 0
    @State private var minutes: Int = 60
    @State private var seconds: Int = 0
    @State private var breakMinutes: Int = 5
    @State private var showTimePicker: Bool = false
    @State private var showBreakPicker: Bool = false
    @State private var labelText: String = ""
    @State private var vibrateOn: Bool = true
    
    var body: some View {
        ZStack {
            // Background
            Color.black.opacity(0.9)
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                // Title
                Text("Timer")
                    .font(.system(size: 34, weight: .bold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                
                // Timer Display
                Button(action: {
                    showTimePicker.toggle()
                }) {
                    Text(String(format: "%02d:%02d:%02d", hours, minutes, seconds))
                        .font(.system(size: 60, weight: .bold, design: .monospaced))
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                .padding(.horizontal)
                
                // Break Duration
                Button(action: {
                    showBreakPicker.toggle()
                }) {
                    HStack {
                        Text("\(breakMinutes)m break")
                            .font(.system(size: 16))
                            .foregroundColor(.gray)
                        Spacer()
                        Image(systemName: "chevron.down")
                            .foregroundColor(.gray)
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 5)
                    .background(Color.gray.opacity(0.2))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                .padding(.horizontal)
                
                // Set Button
                Button(action: {
                    // Logika untuk menyimpan timer
                    print("Timer set: \(hours)h \(minutes)m \(seconds)s, Break: \(breakMinutes)m")
                }) {
                    Text("Set")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                .padding(.horizontal)
                
                // Label Section
                VStack(alignment: .leading, spacing: 10) {
                    Text("Label")
                        .font(.system(size: 16))
                        .foregroundColor(.gray)
                    
                    TextField("Enter label", text: $labelText)
                        .font(.system(size: 16))
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                .padding(.horizontal)
                
                // When Timer Ends Section
                HStack {
                    Text("When Timer Ends")
                        .font(.system(size: 16))
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    HStack {
                        Text("Vibrate")
                            .font(.system(size: 16))
                            .foregroundColor(.white)
                        Image(systemName: "chevron.right")
                            .foregroundColor(.gray)
                    }
                }
                .padding(.horizontal)
                .padding(.vertical, 10)
                .background(Color.gray.opacity(0.2))
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .padding(.horizontal)
                
                // Add as Widget Section
                HStack {
                    Text("Add as widget")
                        .font(.system(size: 16))
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Toggle("", isOn: $vibrateOn)
                        .labelsHidden()
                }
                .padding(.horizontal)
                .padding(.vertical, 10)
                .background(Color.gray.opacity(0.2))
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .padding(.horizontal)
                
                Spacer()
            }
            .padding(.top)
            
            // Time Picker Modal
            if showTimePicker {
                Color.black.opacity(0.8)
                    .ignoresSafeArea()
                
                VStack {
                    HStack {
                        Button("Cancel") {
                            showTimePicker = false
                        }
                        .foregroundColor(.red)
                        
                        Spacer()
                        
                        Button("Done") {
                            showTimePicker = false
                        }
                        .foregroundColor(.blue)
                    }
                    .padding()
                    
                    HStack(spacing: 0) {
                        Picker("Hours", selection: $hours) {
                            ForEach(0..<24) { hour in
                                Text("\(hour)h").tag(hour)
                            }
                        }
                        .pickerStyle(.wheel)
                        
                        Picker("Minutes", selection: $minutes) {
                            ForEach(0..<60) { minute in
                                Text("\(minute)m").tag(minute)
                            }
                        }
                        .pickerStyle(.wheel)
                        
                        Picker("Seconds", selection: $seconds) {
                            ForEach(0..<60) { second in
                                Text("\(second)s").tag(second)
                            }
                        }
                        .pickerStyle(.wheel)
                    }
                    .background(Color.gray.opacity(0.2))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                .padding()
                .background(Color.black.opacity(0.9))
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .padding()
            }
            
            // Break Picker Modal
            if showBreakPicker {
                Color.black.opacity(0.8)
                    .ignoresSafeArea()
                
                VStack {
                    HStack {
                        Button("Cancel") {
                            showBreakPicker = false
                        }
                        .foregroundColor(.red)
                        
                        Spacer()
                        
                        Button("Done") {
                            showBreakPicker = false
                        }
                        .foregroundColor(.blue)
                    }
                    .padding()
                    
                    Picker("Break Duration", selection: $breakMinutes) {
                        ForEach(1..<16) { minute in
                            Text("\(minute)m").tag(minute)
                        }
                    }
                    .pickerStyle(.wheel)
                    .background(Color.gray.opacity(0.2))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                .padding()
                .background(Color.black.opacity(0.9))
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .padding()
            }
        }
    }
}

#Preview {
    TimerSetView()
}
