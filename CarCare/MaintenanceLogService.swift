//
//  MaintenanceLogService.swift
//  CarCare
//
//  Created by Giovanni Nembhard on 11/28/25.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class MaintenanceLogService {
    private let db = Firestore.firestore()
    
    // Add a new maintenance log
    func addLog(carId: String, type: String, date: Date, mileage: Int, notes: String?) async throws {
        guard let uid = Auth.auth().currentUser?.uid else {
            throw NSError(domain: "AuthError", code: 401, userInfo: [NSLocalizedDescriptionKey: "User not logged in"])
        }

        let log = MaintenanceLog(
            carId: carId,
            type: type,
            date: date,
            mileage: mileage,
            notes: notes,
            userId: uid      // REQUIRED FOR FIRESTORE RULES
        )
        
        _ = try db.collection("maintenanceLogs").addDocument(from: log)
    }
    
    // Listen for logs for a specific car
    func logsForCar(carId: String, completion: @escaping ([MaintenanceLog]) -> Void) -> ListenerRegistration {
        return db.collection("maintenanceLogs")
            .whereField("carId", isEqualTo: carId)
            .order(by: "date", descending: true)
            .addSnapshotListener { snapshot, error in
                if let docs = snapshot?.documents {
                    let logs = docs.compactMap { try? $0.data(as: MaintenanceLog.self) }
                    completion(logs)
                } else {
                    completion([])
                }
            }
    }
}
