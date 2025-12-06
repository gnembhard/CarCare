//
//  CarCare_App.swift
//  CarCare+
//
//  Created by Giovanni Nembhard on 11/27/25.
//

import SwiftUI
import Firebase

@main
struct CarCare_App: App {
    @StateObject private var authManager = AuthManager() // ✅ AuthManager

    init() {
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            SplashScreenWrapper()
                .environmentObject(authManager) // Pass AuthManager down
        }
    }
}



