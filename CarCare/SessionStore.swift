//
//  SessionStore.swift
//  CarCare
//
//  Created by Giovanni Nembhard on 11/27/25.
//

import Foundation
import FirebaseAuth
import SwiftUI
internal import Combine

@MainActor
class SessionStore: ObservableObject {
    
    @Published var user: FirebaseAuth.User?
    
    init() {
        self.user = Auth.auth().currentUser
    }
    
    // MARK: - Sign In
    func signIn(email: String, password: String) async -> String? {
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            self.user = result.user
            print("✅ User signed in: \(result.user.email ?? "unknown")")
            return nil
        } catch {
            print("❌ Sign in failed: \(error.localizedDescription)")
            return error.localizedDescription
        }
    }
    
    // MARK: - Sign Out
    func signOut() {
        do {
            try Auth.auth().signOut()
            self.user = nil
            print("👋 User signed out")
        } catch {
            print("❌ Sign out failed: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Sign Up (optional)
    func signUp(email: String, password: String) async -> String? {
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            self.user = result.user
            print("✅ User signed up: \(result.user.email ?? "unknown")")
            return nil
        } catch {
            print("❌ Sign up failed: \(error.localizedDescription)")
            return error.localizedDescription
        }
    }
}

