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
    @Environment(\.modelContext) private var modelContext
    @Query private var breaks: [Break]
    
    init() {
        let today = Calendar.current.startOfDay(for: Date())
        _breaks = Query(filter: #Predicate<Break> { $0.date == today })
    }
    
    @State private var currentScreen: Screen = .home
    @State private var tabIndex: Int = 1
    @State private var isProfileVisible: Bool = false
    @State private var profileDragOffset: CGFloat = UIScreen.main.bounds.height
    @GestureState private var dragState: CGFloat = 0
    @State private var isTimerRunning: Bool = false
    @State private var dragOffset: CGFloat = 0 // Untuk animasi drag carousel
    @State private var profileOpacity: Double = 0.0 // Untuk animasi opacity profile
    
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
                ZStack {
                    // TimerSetView (index 0)
                    TimerSetView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .offset(x: offsetForIndex(0))
                        .opacity(opacityForIndex(0))
                        .allowsHitTesting(tabIndex == 0 && !isTimerRunning)
                        .animation(.interpolatingSpring(stiffness: 200, damping: 25, initialVelocity: 0), value: tabIndex)
                        .animation(.interpolatingSpring(stiffness: 200, damping: 25, initialVelocity: 0), value: dragOffset)
                    
                    // TimerView (index 1)
                    TimerView(breakRecord: latestBreak, isTimerRunning: $isTimerRunning)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .offset(x: offsetForIndex(1))
                        .opacity(opacityForIndex(1))
                        .allowsHitTesting(tabIndex == 1)
                        .animation(.interpolatingSpring(stiffness: 200, damping: 25, initialVelocity: 0), value: tabIndex)
                        .animation(.interpolatingSpring(stiffness: 200, damping: 25, initialVelocity: 0), value: dragOffset)
                    
                    // DataView (index 2)
                    DataView(breaks: breaks)
                        .environmentObject(manager)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .offset(x: offsetForIndex(2))
                        .opacity(opacityForIndex(2))
                        .allowsHitTesting(tabIndex == 2 && !isTimerRunning)
                        .animation(.interpolatingSpring(stiffness: 200, damping: 25, initialVelocity: 0), value: tabIndex)
                        .animation(.interpolatingSpring(stiffness: 200, damping: 25, initialVelocity: 0), value: dragOffset)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(backgroundColor)
                .gesture(
                    isTimerRunning ? nil : DragGesture()
                        .onChanged { value in
                            // Update dragOffset selama swipe
                            dragOffset = value.translation.width
                        }
                        .onEnded { value in
                            // Swipe kiri/kanan untuk ganti halaman
                            let horizontalTranslation = value.translation.width
                            if horizontalTranslation > 50 && tabIndex > 0 {
                                // Swipe kanan -> ke halaman kiri (index lebih kecil)
                                tabIndex -= 1
                                currentScreen = tabScreens[tabIndex]
                            } else if horizontalTranslation < -50 && tabIndex < tabScreens.count - 1 {
                                // Swipe kiri -> ke halaman kanan (index lebih besar)
                                tabIndex += 1
                                currentScreen = tabScreens[tabIndex]
                            }
                            // Swipe atas untuk buka profile hanya dari halaman home
                            let verticalTranslation = value.translation.height
                            if verticalTranslation < -100 && currentScreen == .home {
                                withAnimation(.interpolatingSpring(stiffness: 200, damping: 25, initialVelocity: 0)) {
                                    isProfileVisible = true
                                    currentScreen = .profile
                                    profileDragOffset = 0
                                    profileOpacity = 1.0
                                }
                            }
                            // Reset dragOffset setelah swipe selesai
                            withAnimation(.interpolatingSpring(stiffness: 200, damping: 25, initialVelocity: 0)) {
                                dragOffset = 0
                            }
                        }
                )
                
                ProfileView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(backgroundColor)
                    .offset(y: isProfileVisible ? profileDragOffset + dragState : UIScreen.main.bounds.height + dragState)
                    .opacity(profileOpacity)
                    .animation(.interpolatingSpring(stiffness: 200, damping: 25, initialVelocity: 0), value: profileDragOffset)
                    .animation(.interpolatingSpring(stiffness: 200, damping: 25, initialVelocity: 0), value: profileOpacity)
                    .gesture(
                        isTimerRunning ? nil : DragGesture()
                            .updating($dragState) { value, state, _ in
                                if isProfileVisible {
                                    state = max(0, value.translation.height)
                                }
                            }
                            .onChanged { value in
                                if isProfileVisible {
                                    profileDragOffset = max(0, value.translation.height)
                                    // Update opacity berdasarkan posisi drag
                                    let screenHeight = UIScreen.main.bounds.height
                                    profileOpacity = 1.0 - min(1.0, profileDragOffset / screenHeight)
                                }
                            }
                            .onEnded { value in
                                if value.translation.height > 100 {
                                    withAnimation(.interpolatingSpring(stiffness: 200, damping: 25, initialVelocity: 0)) {
                                        isProfileVisible = false
                                        currentScreen = tabScreens[tabIndex]
                                        profileDragOffset = UIScreen.main.bounds.height
                                        profileOpacity = 0.0
                                    }
                                } else {
                                    withAnimation(.interpolatingSpring(stiffness: 200, damping: 25, initialVelocity: 0)) {
                                        profileDragOffset = 0
                                        profileOpacity = 1.0
                                    }
                                }
                            }
                    )
                    .allowsHitTesting(!isTimerRunning)
                
                // Navigation dots selalu muncul di semua page
                VStack {
                    Spacer()
                    NavigationDotsView(currentScreen: $currentScreen)
                        .padding(.bottom, 30)
                        .allowsHitTesting(!isTimerRunning)
                }
            }
            .navigationBarBackButtonHidden(true)
        }
    }
    
    // Hitung offset untuk tiap halaman
    private func offsetForIndex(_ index: Int) -> CGFloat {
        let screenWidth = UIScreen.main.bounds.width
        let position = CGFloat(index - tabIndex) * screenWidth
        return position + dragOffset
    }
    
    // Hitung opacity untuk tiap halaman
    private func opacityForIndex(_ index: Int) -> Double {
        let screenWidth = UIScreen.main.bounds.width
        let position = abs(CGFloat(index - tabIndex) * screenWidth + dragOffset)
        let opacity = 1.0 - (position / screenWidth) * 0.3
        return max(0.7, min(1.0, opacity))
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

struct NavigationDotsView: View {
    @Binding var currentScreen: Screen
    
    private let screens: [Screen] = [.timer, .home, .data]
    
    var body: some View {
        HStack(spacing: 15) {
            ForEach(screens.indices, id: \.self) { index in
                if index == 1 { // Bulatan tengah (halaman home)
                    Image(systemName: currentScreen == .profile ? "chevron.down" : "chevron.up")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(currentScreen == screens[index] ? .white : .gray.opacity(0.7))
                        .frame(width: 10, height: 25)
                        .animation(.easeInOut(duration: 0.3), value: currentScreen)
                } else {
                    Circle()
                        .frame(width: 10, height: 25)
                        .foregroundColor(currentScreen == screens[index] ? .primaryApp : .gray.opacity(0.7))
                        .animation(.spring(), value: currentScreen)
                }
            }
        }
        .padding(.vertical, 2)
        .padding(.horizontal, 12)
        .background(
            Capsule()
                .fill(Color.gray.opacity(0.3))
        )
    }
}

#Preview {
    ContentView()
        .environmentObject(HealthKitManager())
}
