//
//  ContentView.swift
//  CarCare+
//
//  Created by Giovanni Nembhard on 11/27/25.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var authManager: AuthManager // ✅ Use AuthManager

    var body: some View {
        Group {
            if authManager.user != nil {
                MainTabView() // Your main app content
            } else {
                LoginView()
            }
        }
    }
}

