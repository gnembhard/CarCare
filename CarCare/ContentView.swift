//
//  ContentView.swift
//  CarCare+
//
//  Created by Giovanni Nembhard on 11/27/25.
//

import SwiftUI
import FirebaseAuth

struct ContentView: View {
    @EnvironmentObject var session: SessionStore

    var body: some View {
        Group {
            if session.user == nil {
                AuthFlowView()
            } else {
                MainTabView()
            }
        }
    }
}
