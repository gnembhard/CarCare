//
//  ProfileView.swift
//  CarCare
//
//  Created by Giovanni Nembhard on 11/27/25.
//

import SwiftUI
import FirebaseAuth

struct ProfileView: View {
    @EnvironmentObject var authManager: AuthManager

    var body: some View {
        NavigationStack {
            VStack(spacing: 30) {
                // MARK: - Profile Avatar
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.blue)
                    .padding(.top, 40)

                // MARK: - User Info
                VStack(spacing: 8) {
                    if let user = authManager.user {
                        Text(user.email ?? "No email")
                            .font(.title2)
                            .bold()
                        Text("User ID: \(user.uid.prefix(6))…") // partial UID
                            .font(.caption)
                            .foregroundColor(.gray)
                    } else {
                        Text("Not logged in")
                            .font(.title3)
                            .foregroundColor(.red)
                    }
                }

                Divider()
                    .padding(.horizontal)

                // MARK: - Actions
                VStack(spacing: 15) {
                    NavigationLink(destination: EditProfileView().environmentObject(authManager)) {
                        HStack {
                            Image(systemName: "pencil")
                            Text("Edit Profile")
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.orange)

                    Button(action: {
                        authManager.signOut()
                    }) {
                        HStack {
                            Image(systemName: "arrow.backward.circle")
                            Text("Log Out")
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.red)
                }
                .padding(.horizontal)

                Spacer()
            }
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
