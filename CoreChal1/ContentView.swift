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
                // Ganti TabView dengan ZStack untuk kontrol manual
                ZStack {
                    // TimerSetView (index 0)
                    TimerSetView()
                        .opacity(tabIndex == 0 ? 1 : 0)
                        .allowsHitTesting(tabIndex == 0 && !isTimerRunning)
                    
                    // TimerView (index 1)
                    TimerView(breakRecord: latestBreak, isTimerRunning: $isTimerRunning)
                        .opacity(tabIndex == 1 ? 1 : 0)
                        .allowsHitTesting(tabIndex == 1)
                    
                    // DataView (index 2)
                    DataView(breaks: breaks)
                        .environmentObject(manager)
                        .opacity(tabIndex == 2 ? 1 : 0)
                        .allowsHitTesting(tabIndex == 2 && !isTimerRunning)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(backgroundColor)
                .gesture(
                    isTimerRunning ? nil : DragGesture()
                        .onEnded { value in
                            // Swipe kiri/kanan untuk ganti halaman
                            let horizontalTranslation = value.translation.width
                            if horizontalTranslation > 50 && tabIndex > 0 {
                                // Swipe kanan
                                tabIndex -= 1
                                currentScreen = tabScreens[tabIndex]
                            } else if horizontalTranslation < -50 && tabIndex < tabScreens.count - 1 {
                                // Swipe kiri
                                tabIndex += 1
                                currentScreen = tabScreens[tabIndex]
                            }
                            // Swipe atas untuk buka profile
                            let verticalTranslation = value.translation.height
                            if verticalTranslation < -100 && currentScreen != .profile {
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    isProfileVisible = true
                                    currentScreen = .profile
                                    profileDragOffset = 0
                                }
                            }
                        }
                )
                
                ProfileView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(backgroundColor)
                    .offset(y: isProfileVisible ? profileDragOffset + dragState : UIScreen.main.bounds.height + dragState)
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
                                }
                            }
                            .onEnded { value in
                                if value.translation.height > 100 {
                                    withAnimation(.easeInOut(duration: 0.3)) {
                                        isProfileVisible = false
                                        currentScreen = tabScreens[tabIndex]
                                        profileDragOffset = UIScreen.main.bounds.height
                                    }
                                } else {
                                    withAnimation(.easeInOut(duration: 0.3)) {
                                        profileDragOffset = 0
                                    }
                                }
                            }
                    )
                    .allowsHitTesting(!isTimerRunning)
                
                if currentScreen != .profile {
                    VStack {
                        Spacer()
                        NavigationDotsView(currentScreen: $currentScreen)
                            .padding(.bottom, 30)
                            .allowsHitTesting(!isTimerRunning)
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

struct NavigationDotsView: View {
    @Binding var currentScreen: Screen
    
    private let screens: [Screen] = [.timer, .home, .data]
    
    var body: some View {
        HStack(spacing: 15) {
            ForEach(screens, id: \.self) { screen in
                Circle()
                    .frame(width: 10, height: 25)
                    .foregroundColor(currentScreen == screen ? .primaryApp : .gray.opacity(0.7))
                    .animation(.spring(), value: currentScreen)
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
