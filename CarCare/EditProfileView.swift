//
//  EditProfileView.swift
//  CarCare
//
//  Created by Giovanni Nembhard on 11/29/25.
//

import SwiftUI
import PhotosUI
import FirebaseAuth

struct EditProfileView: View {
    @EnvironmentObject var authManager: AuthManager

    @State private var newEmail: String = ""
    @State private var newPassword: String = ""
    @State private var selectedImage: PhotosPickerItem?
    @State private var profileImage: UIImage?

    @State private var message: String = ""
    @State private var showMessage: Bool = false

    var body: some View {
        Form {
            // MARK: - Profile Image
            Section(header: Text("Profile Picture")) {
                VStack {
                    if let profileImage = profileImage {
                        Image(uiImage: profileImage)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
                            .padding(.bottom, 5)
                    } else {
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .frame(width: 100, height: 100)
                            .foregroundColor(.blue)
                    }

                    PhotosPicker("Choose Photo", selection: $selectedImage, matching: .images)
                        .onChange(of: selectedImage) { _old, newItem in
                            Task {
                                if let data = try? await selectedImage?.loadTransferable(type: Data.self),
                                   let uiImage = UIImage(data: data) {
                                    self.profileImage = uiImage
                                    uploadProfileImage()
                                }
                            }
                        }
                }
                .frame(maxWidth: .infinity, alignment: .center)
            }

            // MARK: - Update Email
            Section(header: Text("Email")) {
                TextField("New Email", text: $newEmail)
                    .keyboardType(.emailAddress)

                Button("Update Email") {
                    updateEmail()
                }
                .disabled(newEmail.isEmpty)
            }

            // MARK: - Update Password
            Section(header: Text("Password")) {
                SecureField("New Password", text: $newPassword)

                Button("Update Password") {
                    updatePassword()
                }
                .disabled(newPassword.count < 6)
            }
        }
        .navigationTitle("Edit Profile")
        .alert(message, isPresented: $showMessage) {
            Button("OK", role: .cancel) {}
        }
        .onAppear {
            if let email = authManager.user?.email {
                newEmail = email
            }
        }
    }

    // MARK: - Email Update
    private func updateEmail() {
        authManager.updateEmail(newEmail) { success, error in
            if success {
                message = "A verification email has been sent to update your email."
            } else {
                message = error?.localizedDescription ?? "Failed to update email."
            }
            showMessage = true
        }
    }

    // MARK: - Password Update
    private func updatePassword() {
        authManager.updatePassword(newPassword) { success, error in
            if success {
                message = "Password updated successfully!"
            } else {
                message = error?.localizedDescription ?? "Failed to update password."
            }
            showMessage = true
        }
    }

    // MARK: - Image Upload
    private func uploadProfileImage() {
        guard let image = profileImage else { return }

        authManager.updateProfileImage(image) { success, error in
            if success {
                message = "Profile picture updated!"
            } else {
                message = error?.localizedDescription ?? "Failed to upload image."
            }
            showMessage = true
        }
    }
}
