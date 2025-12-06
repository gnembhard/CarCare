//
//  SplashScreenWrapper.swift
//  CarCare
//
//  Created by Giovanni Nembhard on 11/29/25.
//

import SwiftUI

struct SplashScreenWrapper: View {
    @EnvironmentObject var authManager: AuthManager
    @State private var showMain = false

    var body: some View {
        if showMain {
            ContentView()
                .environmentObject(authManager) // Main app after splash
        } else {
            SplashScreen {
                showMain = true // called when splash finishes
            }
        }
    }
}
