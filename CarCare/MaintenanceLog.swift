//
//  MaintenanceLog.swift
//  CarCare
//
//  Created by Giovanni Nembhard on 11/27/25.
//

import Foundation
import FirebaseFirestore

struct MaintenanceLog: Identifiable, Codable {
    @DocumentID var id: String?
    var carId: String
    var type: String
    var date: Date
    var mileage: Int
    var notes: String?
    var userId: String
}
