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
    @EnvironmentObject var manager: HealthKitManager
    @State private var currentScreen: Screen = .home
    @State private var tabIndex: Int = 1 // Index untuk TabView: 0 = timer, 1 = home, 2 = data
    @State private var isProfileVisible: Bool = false // Untuk mengontrol visibilitas layar profile
    
    // Urutan layar untuk TabView (hanya untuk timer, home, data)
    private let tabScreens: [Screen] = [.timer, .home, .data]
    
    var body: some View {
        NavigationStack {
            ZStack {
                // TabView untuk swipe kiri-kanan antar layar timer, home, dan data
                TabView(selection: $tabIndex) {
                    TimerSetView()
                        .tag(0)
                    
                    TimerView()
                        .tag(1)
                    
                    DataView()
                        .environmentObject(manager)
                        .tag(2)
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never)) // Gaya carousel tanpa indikator bawaan
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(backgroundColor)
                .onChange(of: tabIndex) { newIndex in
                    // Update currentScreen berdasarkan tabIndex
                    currentScreen = tabScreens[newIndex]
                }
                .gesture(
                    DragGesture()
                        .onEnded { value in
                            // Hanya aktifkan gesture atas/bawah jika tidak ada modal lain yang terbuka
                            if value.translation.height < -100 && currentScreen != .profile {
                                // Geser ke atas dari layar apapun (kecuali profile) ke profile
                                withAnimation(.spring()) {
                                    isProfileVisible = true
                                    currentScreen = .profile
                                }
                            }
                        }
                )
                
                // Layar Profile sebagai overlay
                if isProfileVisible {
                    ProfileView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(backgroundColor)
                        .gesture(
                            DragGesture()
                                .onEnded { value in
                                    if value.translation.height > 100 {
                                        // Geser ke bawah dari profile ke layar sebelumnya
                                        withAnimation(.spring()) {
                                            isProfileVisible = false
                                            // Kembalikan ke layar yang sesuai dengan tabIndex
                                            currentScreen = tabScreens[tabIndex]
                                        }
                                    }
                                }
                        )
                }
                
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
        case .home: return Color.primaryApp
        case .profile: return Color.primaryApp
        case .data: return Color.primaryApp
        case .timer: return Color.primaryApp
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
                    .foregroundColor(currentScreen == screen ? .primaryApp : .gray.opacity(0.7)) // Hitam untuk aktif, abu-abu tua untuk tidak aktif
                    .animation(.spring(), value: currentScreen)
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
        .environmentObject(HealthKitManager()) // Tambahkan environmentObject untuk preview
}
