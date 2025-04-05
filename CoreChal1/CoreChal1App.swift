//
//  CoreChal1App.swift
//  CoreChal1
//
//  Created by Hendrik Nicolas Carlo on 20/03/25.
//

import SwiftUI
import SwiftData

@main
struct CoreChal1App: App {
    var body: some Scene {
        WindowGroup {
            SplashScreenView() // Atur SplashScreenView sebagai view awal
                .modelContainer(for: Item.self)
        }
    }
}
