//
//  AuthManager.swift
//  CarCare
//
//  Created by Giovanni Nembhard on 11/28/25.
//

import Foundation
import FirebaseAuth
import FirebaseStorage
import SwiftUI
internal import Combine

@MainActor
class AuthManager: ObservableObject {
    @Published var user: User? = Auth.auth().currentUser
    @Published var errorText: String = ""

    // MARK: - Sign Up
    func signUp(email: String, password: String) {
        Task {
            do {
                let result = try await Auth.auth().createUser(withEmail: email, password: password)
                self.user = result.user
                print("Signed up: \(result.user.email ?? "")")
            } catch let error as NSError {
                self.errorText = error.localizedDescription
                print("Sign up failed: \(error), \(error.userInfo)")
            }
        }
    }

    // MARK: - Sign In
    func signIn(email: String, password: String) {
        Task {
            do {
                let result = try await Auth.auth().signIn(withEmail: email, password: password)
                self.user = result.user
                print(" Signed in: \(result.user.email ?? "")")
            } catch let error as NSError {
                self.errorText = error.localizedDescription
                print("Sign in failed: \(error), \(error.userInfo)")
            }
        }
    }

    // MARK: - Sign Out
    func signOut() {
        do {
            try Auth.auth().signOut()
            self.user = nil
            print(" User signed out")
        } catch let error as NSError {
            print("Sign out failed: \(error), \(error.userInfo)")
        }
    }
    
    func updateEmail(_ email: String, completion: @escaping (Bool, Error?) -> Void) {
        guard let user = Auth.auth().currentUser else { completion(false, nil); return }
        
        // This will send a verification email before updating the email
        user.sendEmailVerification(beforeUpdatingEmail: email) { error in
            if let error = error {
                completion(false, error)
            } else {
                // Email verification sent successfully
                completion(true, nil)
            }
        }
    }

    
    // MARK: - Update Password
    func updatePassword(_ password: String, completion: @escaping (Bool, Error?) -> Void) {
        guard let user = Auth.auth().currentUser else { completion(false, nil); return }
        user.updatePassword(to: password) { error in
            if let error = error {
                completion(false, error)
            } else {
                completion(true, nil)
            }
        }
    }
    
    // MARK: - Update Profile Image
    func updateProfileImage(_ image: UIImage, completion: @escaping (Bool, Error?) -> Void) {
        guard let user = Auth.auth().currentUser else { completion(false, nil); return }
        
        let storageRef = Storage.storage().reference().child("profile_images/\(user.uid).jpg")
        guard let imageData = image.jpegData(compressionQuality: 0.5) else { completion(false, nil); return }
        
        storageRef.putData(imageData, metadata: nil) { _, error in
            if let error = error {
                completion(false, error)
                return
            }
            
            storageRef.downloadURL { url, error in
                if let error = error {
                    completion(false, error)
                    return
                }
                
                guard let urlString = url?.absoluteString else { completion(false, nil); return }
                
                let changeRequest = user.createProfileChangeRequest()
                changeRequest.photoURL = URL(string: urlString)
                changeRequest.commitChanges { error in
                    if let error = error {
                        completion(false, error)
                    } else {
                        self.user = Auth.auth().currentUser
                        completion(true, nil)
                    }
                }
            }
        }
    }
}
