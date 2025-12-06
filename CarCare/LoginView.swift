//
//  LoginView.swift
//  CarCare
//
//  Created by Giovanni Nembhard on 11/27/25.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var authManager: AuthManager
    @State private var email = ""
    @State private var password = ""
    @State private var showSignup = false

    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                colors: [Color.blue.opacity(0.6), Color.blue.opacity(0.2)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 30) {
                // App title / heading
                VStack(spacing: 5) {
                    Text(showSignup ? "Sign Up" : "Login")
                        .font(.system(size: 36, weight: .bold))
                        .foregroundColor(.white)
                    
                    Text("Welcome back! Please \(showSignup ? "sign up" : "login") to continue.")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.8))
                        .multilineTextAlignment(.center)
                }
                .padding(.bottom, 20)
                
                // Input fields
                VStack(spacing: 15) {
                    TextField("Email", text: $email)
                        .keyboardType(.emailAddress)
                        .textInputAutocapitalization(.never)
                        .padding()
                        .background(Color.white.opacity(0.2))
                        .cornerRadius(12)
                        .foregroundColor(.white)
                        .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.white.opacity(0.5)))
                    
                    SecureField("Password", text: $password)
                        .padding()
                        .background(Color.white.opacity(0.2))
                        .cornerRadius(12)
                        .foregroundColor(.white)
                        .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.white.opacity(0.5)))
                }

                // Error message
                if !authManager.errorText.isEmpty {
                    Text(authManager.errorText)
                        .foregroundColor(.red)
                        .font(.footnote)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }

                // Action button
                Button(action: {
                    if showSignup {
                        authManager.signUp(email: email, password: password)
                    } else {
                        authManager.signIn(email: email, password: password)
                    }
                }) {
                    Text(showSignup ? "Create Account" : "Login")
                        .font(.headline)
                        .foregroundColor(.blue)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(12)
                        .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 5)
                }
                .padding(.top)

                // Toggle signup/login
                Button(action: {
                    showSignup.toggle()
                    authManager.errorText = ""
                }) {
                    Text(showSignup ? "Already have an account? Login" : "Don't have an account? Sign Up")
                        .foregroundColor(.white)
                        .font(.subheadline)
                        .bold()
                }
                .padding(.top, 5)
            }
            .padding(.horizontal, 30)
        }
    }
}
