//
//  Car.swift
//  CarCare
//
//  Created by Giovanni Nembhard on 11/27/25.
//

import Foundation
import FirebaseFirestore

struct Car: Identifiable, Codable {
    @DocumentID var id: String?
    var make: String
    var model: String
    var year: Int
    var mileage: Int
    var oilCapacity: Double?
    var nextOilChange: Date?
    var notes: String?
    var userId: String
    var vin: String?
    var bodyStyle: String?
    var drivetrain: String?
    var engine: String?
    var trim: String?
    var transmission: String?
    var imageURL: String?


}
