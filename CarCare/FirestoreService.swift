//
//  FirestoreService.swift
//  CarCare
//
//  Created by Giovanni Nembhard on 11/27/25.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class FirestoreService {
    private let db = Firestore.firestore()
    
    // MARK: - Add Car
    func addCar(_ car: Car) async throws {
        try await db.collection("cars").addDocument(from: car)
    }
    
    // MARK: - Update Car
    func updateCar(_ car: Car, completion: @escaping (Error?) -> Void) {
        guard let id = car.id else { completion(nil); return }
        do {
            try db.collection("cars").document(id).setData(from: car, merge: true)
            completion(nil)
        } catch {
            completion(error)
        }
    }
    
    // MARK: - Add Maintenance Log to Subcollection
    func addLog(carId: String, log: MaintenanceLog) async throws {
        let logRef = db.collection("cars")
            .document(carId)
            .collection("maintenanceLogs")
            .document(log.id ?? UUID().uuidString)
        
        try logRef.setData(from: log)
    }
    
    // MARK: - Listen Maintenance Logs for a Car
    func logsForCar(carId: String, completion: @escaping ([MaintenanceLog]) -> Void) -> ListenerRegistration {
        guard !carId.isEmpty else {
            print("Invalid carId")
            completion([])
            return db.collection("cars").document("dummy").collection("maintenanceLogs")
                .addSnapshotListener { _, _ in }
        }
        
        guard let uid = Auth.auth().currentUser?.uid else {
            print("No logged-in user")
            completion([])
            return db.collection("cars").document(carId).collection("maintenanceLogs")
                .addSnapshotListener { _, _ in }
        }
        
        print("Listening for carId:", carId, "with UID:", uid)
        
        return db.collection("cars")
            .document(carId)
            .collection("maintenanceLogs")
            .whereField("userId", isEqualTo: uid)
            .order(by: "date", descending: true)
            .addSnapshotListener { snapshot, error in
                if let error = error {
                    print("Error fetching logs:", error.localizedDescription)
                    completion([])
                    return
                }
                
                let logs = snapshot?.documents.compactMap { doc -> MaintenanceLog? in
                    do {
                        return try doc.data(as: MaintenanceLog.self)
                    } catch {
                        print("Error decoding log:", error.localizedDescription)
                        return nil
                    }
                } ?? []
                
                print("Fetched logs count:", logs.count)
                completion(logs)
            }
    }
    
    // MARK: - Delete Individual Log
    func deleteLog(carId: String, logId: String, completion: @escaping (Error?) -> Void) {
        db.collection("cars")
            .document(carId)
            .collection("maintenanceLogs")
            .document(logId)
            .delete { error in
                completion(error)
            }
    }
    
    // MARK: - Optional: Remove Listener
    func removeListener(_ listener: ListenerRegistration?) {
        listener?.remove()
    }
}
