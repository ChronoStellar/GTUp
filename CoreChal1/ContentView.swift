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
    //move to onboarding if app calls onboarding first
    @EnvironmentObject var manager: HealthKitManager
    @Environment(\.modelContext) private var modelContext
    @Query private var breaks: [Break]
    
    init() {
        let today = Calendar.current.startOfDay(for: Date())
        _breaks = Query(filter: #Predicate<Break> { $0.date == today })
    }
    
    
    @State private var currentScreen: Screen = .home
    @State private var tabIndex: Int = 1 // Index untuk TabView: 0 = timer, 1 = home, 2 = data
    @State private var isProfileVisible: Bool = false // Untuk mengontrol visibilitas layar profile
    @State private var profileDragOffset: CGFloat = UIScreen.main.bounds.height // Offset awal di luar layar (bawah)
    @GestureState private var dragState: CGFloat = 0 // Melacak posisi drag secara real-time
    
    // Urutan layar untuk TabView (hanya untuk timer, home, data)
    private let tabScreens: [Screen] = [.timer, .home, .data]
    
    private var latestBreak: Break {
        if let lastBreak = breaks.last {
            return lastBreak
        } else {
            let newBreak = Break(date: Date(), stepCounter: 0, breakCounter: 0)
            modelContext.insert(newBreak)
            return newBreak
        }
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                // TabView untuk swipe kiri-kanan antar layar timer, home, dan data
                TabView(selection: $tabIndex) {
                    TimerSetView()
                        .tag(0)
                    
                    TimerView(breakRecord: latestBreak)
                        .tag(1)
                    
                    TestView()
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
                        .updating($dragState) { value, state, _ in
                            // Hanya aktifkan drag ke atas jika layar profile belum terlihat
                            if !isProfileVisible {
                                state = min(0, value.translation.height) // Hanya izinkan drag ke atas (negatif)
                            }
                        }
                        .onEnded { value in
                            // Hanya aktifkan gesture atas/bawah jika tidak ada modal lain yang terbuka
                            if value.translation.height < -100 && currentScreen != .profile {
                                // Geser ke atas dari layar apapun (kecuali profile) ke profile
                                withAnimation(.easeInOut(duration: 0.3)) { // Animasi mirip carousel
                                    isProfileVisible = true
                                    currentScreen = .profile
                                    profileDragOffset = 0 // Posisi akhir (layar penuh)
                                }
                            } else {
                                // Kembalikan ke posisi awal jika tidak cukup swipe
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    profileDragOffset = UIScreen.main.bounds.height
                                }
                            }
                        }
                )
                
                // Layar Profile sebagai overlay
                ProfileView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(backgroundColor)
                    .offset(y: isProfileVisible ? profileDragOffset + dragState : UIScreen.main.bounds.height + dragState)
                    .gesture(
                        DragGesture()
                            .updating($dragState) { value, state, _ in
                                // Hanya izinkan drag ke bawah (positif) saat layar profile terlihat
                                if isProfileVisible {
                                    state = max(0, value.translation.height) // Hanya izinkan drag ke bawah
                                }
                            }
                            .onChanged { value in
                                // Update offset selama drag
                                if isProfileVisible {
                                    profileDragOffset = max(0, value.translation.height)
                                }
                            }
                            .onEnded { value in
                                if value.translation.height > 100 {
                                    // Swipe ke bawah berhasil menutup
                                    withAnimation(.easeInOut(duration: 0.3)) { // Animasi mirip carousel
                                        isProfileVisible = false
                                        currentScreen = tabScreens[tabIndex]
                                        profileDragOffset = UIScreen.main.bounds.height // Kembali ke posisi awal (di luar layar)
                                    }
                                } else {
                                    // Balik ke posisi semula jika tidak cukup swipe
                                    withAnimation(.easeInOut(duration: 0.3)) {
                                        profileDragOffset = 0
                                    }
                                }
                            }
                    )
                
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
