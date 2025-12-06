//
//  EditCarView.swift
//  CarCare
//
//  Created by Giovanni Nembhard on 11/29/25.
//

import SwiftUI

struct EditCarView: View {
    @Environment(\.dismiss) var dismiss
    @State var car: Car
    let service = FirestoreService()
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Vehicle Info")) {
                    TextField("Make", text: $car.make)
                    TextField("Model", text: $car.model)
                    TextField("Year", value: $car.year, formatter: NumberFormatter())
                        .keyboardType(.numberPad)
                }
                
                Section(header: Text("Mileage")) {
                    TextField("Mileage", value: $car.mileage, formatter: NumberFormatter())
                        .keyboardType(.numberPad)
                }
                
                Section(header: Text("Oil Capacity (qt)")) {
                    TextField("Oil Capacity", value: Binding(
                        get: { car.oilCapacity ?? 0 },
                        set: { car.oilCapacity = $0 }
                    ), formatter: NumberFormatter())
                        .keyboardType(.decimalPad)
                }
            }
            .navigationTitle("Edit Car")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") { saveChanges() }
                        .bold()
                }
            }
        }
    }
    
    func saveChanges() {
        service.updateCar(car) { error in
            if let error = error {
                print("Failed to update car:", error.localizedDescription)
            } else {
                print("Car updated successfully")
                dismiss()
            }
        }
    }
}

