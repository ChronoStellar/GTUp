// ContentView.swift
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
                                currentScreen = .data
                            } else if value.translation.width > 100 {
                                currentScreen = .profile
                            } else if value.translation.height < -100 {
                                currentScreen = .timer
                            }
                        case .profile:
                            if value.translation.width < -100 {
                                currentScreen = .home
                            }
                        case .data:
                            if value.translation.width > 100 {
                                currentScreen = .home
                            }
                        case .timer:
                            if value.translation.height > 100 {
                                currentScreen = .home
                            }
                        }
                    }
            )
            .animation(.easeInOut, value: currentScreen)
            .navigationBarBackButtonHidden(true)
        }
    }
    
    private var backgroundColor: Color {
        switch currentScreen {
        case .home: return Color.gray.opacity(0.2)
        case .profile: return Color.blue.opacity(0.2)
        case .data: return Color.green.opacity(0.2)
        case .timer: return Color.red.opacity(0.2)
        }
    }
}


#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
