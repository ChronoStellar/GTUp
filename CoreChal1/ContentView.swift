//
//  ContentView.swift
//  CoreChal1
//
//  Created by Hendrik Nicolas Carlo on 20/03/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @State private var currentScreen: String = "Home"

        var body: some View {
            NavigationStack {
                VStack {
                    TimerView()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.gray.opacity(0.2))
                .gesture(
                    DragGesture()
                        .onEnded { value in
                            if value.translation.width < -100 {
                                // Swiped Left → Go to ProfileView
                                currentScreen = "Data"
                            } else if value.translation.width > 100 {
                                // Swiped Right → Go to DataView
                                currentScreen = "Profile"
                            } else if value.translation.height < -100 {
                                // Swiped Up → Go to TimerSetView
                                currentScreen = "Timer"
                            }
                        }
                )
                .navigationDestination(isPresented: Binding(
                    get: { currentScreen != "Home" },
                    set: { if !$0 { currentScreen = "Home" } }
                )) {
                    switch currentScreen {
                    case "Profile":
                        ProfileView()
                        .navigationBarBackButtonHidden(true)
                    case "Data":
                        DataView()
                        .navigationBarBackButtonHidden(true)
                    case "Timer":
                        TimerSetView()
                        .navigationBarBackButtonHidden(true)
                    default:
                        TimerView()
                        .navigationBarBackButtonHidden(true)
                    }
                }
                .animation(.easeInOut, value: currentScreen)
                
            }
        }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
