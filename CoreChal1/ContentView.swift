//
//  ContentView.swift
//  CoreChal1
//
//  Created by Hendrik Nicolas Carlo on 24/03/25.
//

import SwiftUI
import SwiftData

enum Screen {
    case home
    case profile
    case data
    case timer
}

struct ContentView: View {
    @State private var currentScreen: Screen = .home
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    switch currentScreen {
                    case .home:
                        TimerView()
                    case .profile:
                        ProfileView()
                    case .data:
                        DataView()
                    case .timer:
                        TimerSetView()
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(backgroundColor)
                .gesture(
                    DragGesture()
                        .onEnded { value in
                            switch currentScreen {
                            case .home:
                                if value.translation.width < -100 {
                                    currentScreen = .data // Geser kiri dari Home ke Data
                                } else if value.translation.width > 100 {
                                    currentScreen = .timer // Geser kanan dari Home ke Timer
                                } else if value.translation.height < -100 {
                                    currentScreen = .profile // Geser atas dari Home ke Profile
                                }
                            case .timer:
                                if value.translation.width < -100 {
                                    currentScreen = .home // Geser kiri dari Timer ke Home
                                }
                            case .data:
                                if value.translation.width > 100 {
                                    currentScreen = .home // Geser kanan dari Data ke Home
                                }
                            case .profile:
                                if value.translation.height > 100 {
                                    currentScreen = .home // Geser bawah dari Profile ke Home
                                }
                            }
                        }
                )
                .animation(.easeInOut, value: currentScreen)
                
                // Navigation Dots di bagian bawah (hanya untuk .timer, .home, .data)
                if currentScreen != .profile {
                    VStack {
                        Spacer()
                        NavigationDotsView(currentScreen: $currentScreen)
                            .padding(.bottom, 30) // Sesuaikan jarak dari bawah
                    }
                }
            }
            .navigationBarBackButtonHidden(true)
        }
    }
    
    private var backgroundColor: Color {
        switch currentScreen {
        case .home: return Color.primary
        case .profile: return Color.primary
        case .data: return Color.primary
        case .timer: return Color.primary
        }
    }
}

// Komponen Navigation Dots
struct NavigationDotsView: View {
    @Binding var currentScreen: Screen
    
    // Urutan halaman: Timer (kiri), Home (tengah), Data (kanan)
    private let screens: [Screen] = [.timer, .home, .data]
    
    var body: some View {
        HStack(spacing: 15) {
            ForEach(screens, id: \.self) { screen in
                Circle()
                    .frame(width: 10, height: 25)
                    .foregroundColor(currentScreen == screen ? .black : .gray.opacity(0.7)) // Hitam untuk aktif, abu-abu tua untuk tidak aktif
                    .animation(.easeInOut, value: currentScreen)
            }
        }
        .padding(.vertical, 2) // Padding vertikal untuk kapsul
        .padding(.horizontal, 12) // Padding horizontal untuk kapsul
        .background(
            Capsule()
                .fill(Color.gray.opacity(0.3)) // Warna abu-abu untuk kapsul
        )
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
