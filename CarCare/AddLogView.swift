//
//  AddLogView.swift
//  CarCare
//
//  Created by Giovanni Nembhard on 11/27/25.
//

import SwiftUI
import FirebaseAuth

struct AddLogView: View {
    @Environment(\.dismiss) var dismiss
    var car: Car
    var onSave: (() -> Void)? = nil

    @State private var type = "Oil Change"
    @State private var date = Date()
    @State private var mileage = ""
    @State private var notes = ""
    @State private var errorText = ""
    private let service = FirestoreService()

    let types = ["Oil Change", "Tire Rotation", "Brake Service", "Inspection", "Other"]

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Picker("Type", selection: $type) {
                    ForEach(types, id: \.self) { Text($0) }
                }
                .pickerStyle(.menu)

                DatePicker("Date", selection: $date, displayedComponents: .date)

                TextField("Mileage", text: $mileage)
                    .keyboardType(.numberPad)
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                TextField("Notes", text: $notes)
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                if !errorText.isEmpty {
                    Text(errorText).foregroundColor(.red)
                }

                Button("Save") { save() }
                    .buttonStyle(.borderedProminent)

                Spacer(minLength: 40)
            }
            .padding()
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
    }

    private func save() {
        guard let uid = Auth.auth().currentUser?.uid else {
            errorText = "Not logged in"
            return
        }
        guard let m = Int(mileage) else {
            errorText = "Invalid mileage"
            return
        }
        guard let carId = car.id else {
            errorText = "Invalid car ID"
            return
        }

        let log = MaintenanceLog(
            carId: carId,
            type: type,
            date: date,
            mileage: m,
            notes: notes.isEmpty ? nil : notes,
            userId: uid
        )

        Task {
            do {
                try await service.addLog(carId: carId, log: log)
                onSave?() // refresh parent view
                dismiss()
            } catch {
                errorText = error.localizedDescription
            }
        }
    }
}

