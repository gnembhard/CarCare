//
//  CarService.swift
//  CarCare
//
//  Created by Giovanni Nembhard on 11/27/25.
//

import FirebaseFirestore
import FirebaseAuth

class CarService {
    private let db = Firestore.firestore()

    func getCars(for userId: String, completion: @escaping ([Car]) -> Void) {
        db.collection("cars")
            .whereField("userId", isEqualTo: userId)
            .getDocuments { snapshot, error in
                guard let documents = snapshot?.documents, error == nil else {
                    completion([])
                    return
                }

                let cars: [Car] = documents.compactMap { doc in
                    try? doc.data(as: Car.self)
                }

                completion(cars)
            }
    }

    func addCar(_ car: Car, completion: @escaping (Bool) -> Void) {
        do {
            _ = try db.collection("cars").addDocument(from: car)
            completion(true)
        } catch {
            print("Error adding car:", error.localizedDescription)
            completion(false)
        }
    }

    // Delete Car
    func deleteCar(carId: String, completion: @escaping (Bool, Error?) -> Void) {
        db.collection("cars").document(carId).delete { error in
            if let error = error {
                print("Error deleting car:", error.localizedDescription)
                completion(false, error)
            } else {
                completion(true, nil)
            }
        }
    }
}

