//
//  MaintenanceView.swift
//  CarCare
//
//  Created by Giovanni Nembhard on 11/28/25.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct MaintenanceView: View {
    var car: Car
    @State private var logs: [MaintenanceLog] = []
    @State private var errorText = ""
    private let service = FirestoreService()
    @State private var listener: ListenerRegistration?

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                if logs.isEmpty {
                    Text("No maintenance logs yet.")
                        .foregroundColor(.gray)
                        .padding(.top, 50)
                } else {
                    ForEach(logs) { log in
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text(log.type)
                                    .font(.headline)
                                    .foregroundColor(.blue)
                                Spacer()
                                Text(log.date.formatted(.dateTime.month().day().year()))
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }

                            HStack {
                                Text("Mileage: \(log.mileage)")
                                    .font(.subheadline)
                                Spacer()
                            }

                            if let notes = log.notes, !notes.isEmpty {
                                Text("Notes: \(notes)")
                                    .font(.footnote)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color(UIColor.secondarySystemBackground))
                                .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 5)
                        )
                        .padding(.horizontal)
                    }
                }
            }
            .padding(.top)
        }
        .navigationTitle("\(car.make) \(car.model) Logs")
        .onAppear {
            listener = service.logsForCar(carId: car.id ?? "") { fetchedLogs in
                logs = fetchedLogs
            }
        }
        .onDisappear {
            listener?.remove()
        }
    }
}
