//
//  CarDetailView.swift
//  CarCare
//
//  Created by Giovanni Nembhard on 11/27/25.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import UserNotifications

// MARK: - Service Intervals (Fixed interval services)
struct ServiceType {
    let name: String
    let intervalMiles: Int
}

// Only Oil, Tire Rotation, and Inspection
let serviceIntervals: [ServiceType] = [
    ServiceType(name: "Oil Change", intervalMiles: 5000),
    ServiceType(name: "Tire Rotation", intervalMiles: 6000),
    ServiceType(name: "Inspection", intervalMiles: 12000)
]

// MARK: - Next Due Service Based on Current Mileage
func nextDueService(currentMileage: Int) -> [(name: String, dueAt: Int)] {
    return serviceIntervals.map { ($0.name, currentMileage + $0.intervalMiles) }
}

// MARK: - Schedule Local Notification
func scheduleServiceReminder(serviceName: String, car: Car, dueMileage: Int) {
    let content = UNMutableNotificationContent()
    content.title = "\(serviceName) Due"
    content.body = "Your \(serviceName) is due for \(car.make) \(car.model) at \(dueMileage) miles."
    content.sound = .default

    // Trigger in 5 seconds for demo; replace with actual logic
    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)

    let request = UNNotificationRequest(
        identifier: UUID().uuidString,
        content: content,
        trigger: trigger
    )

    UNUserNotificationCenter.current().add(request) { error in
        if let error = error {
            print("Failed to schedule notification:", error.localizedDescription)
        } else {
            print("Notification scheduled for \(serviceName) at \(dueMileage) miles")
        }
    }
}

// MARK: - Car Detail View
struct CarDetailView: View {
    @State var car: Car
    @State private var logs: [MaintenanceLog] = []
    @State private var listener: ListenerRegistration?
    private let service = FirestoreService()
    @State private var showAddLog = false
    @State private var showEditCar = false
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                // Car Info
                VStack(alignment: .leading, spacing: 6) {
                    Text("\(String(car.year)) \(car.make) \(car.model)")
                        .font(.title2).bold()
                    Text("Mileage: \(car.mileage)")
                    if let oil = car.oilCapacity {
                        Text("Oil Capacity: \(oil, specifier: "%.2f") qt (approx)")
                    } else {
                        Text("Oil Capacity: unknown")
                    }
                }
                .padding()

                Divider()

                // Maintenance Header
                HStack {
                    Text("Maintenance History").font(.headline)
                    Spacer()
                    Button(action: { showAddLog = true }) {
                        Image(systemName: "plus.circle")
                            .font(.title2)
                    }
                }
                .padding(.horizontal)

                // Maintenance Logs List with deletion
                if logs.isEmpty {
                    Text("No maintenance records yet.")
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    List {
                        ForEach(logs) { log in
                            VStack(alignment: .leading) {
                                Text(log.type).bold()
                                Text("Date: \(log.date.formatted(date: .abbreviated, time: .omitted)) • Mileage: \(log.mileage)")
                                    .font(.caption)
                                if let n = log.notes {
                                    Text(n).font(.caption2)
                                }
                            }
                        }
                        .onDelete { indexSet in
                            deleteLogs(at: indexSet)
                        }
                    }
                    .frame(height: CGFloat(logs.count) * 70)
                }

                Divider()

                // Upcoming Services
                VStack(alignment: .leading, spacing: 6) {
                    Text("Upcoming Services").font(.headline)

                    let dueServices = nextDueService(currentMileage: car.mileage)

                    ForEach(dueServices, id: \.name) { service in
                        Text("\(service.name) due at \(service.dueAt) miles")
                            .foregroundColor(car.mileage >= service.dueAt ? .red : .primary)
                            .onAppear {
                                if car.mileage >= service.dueAt {
                                    scheduleServiceReminder(serviceName: service.name, car: car, dueMileage: service.dueAt)
                                }
                            }
                    }
                }
                .padding()

                Spacer()
            }
        }
        .navigationTitle("Details")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Edit") {
                    showEditCar = true
                }
            }
        }
        .sheet(isPresented: $showAddLog) {
            AddLogView(car: car) {
                setupListener()
            }
        }
        .sheet(isPresented: $showEditCar, onDismiss: {
            // Refresh UI after editing if needed
        }) {
            EditCarView(car: car)
        }
        .onAppear {
            // Request notification permission
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
                if let error = error { print(error.localizedDescription) }
            }
            setupListener()
        }
        .onDisappear {
            listener?.remove()
        }
    }

    // MARK: - Listener Setup
    private func setupListener() {
        listener?.remove()
        listener = service.logsForCar(carId: car.id ?? "") { fetchedLogs in
            self.logs = fetchedLogs
        }
    }

    // MARK: - Delete Individual Logs
    private func deleteLogs(at offsets: IndexSet) {
        guard let carId = car.id else { return }

        for index in offsets {
            let log = logs[index]
            guard let logId = log.id else { continue }

            service.deleteLog(carId: carId, logId: logId) { error in
                if let error = error {
                    print("Failed to delete log: \(error.localizedDescription)")
                } else {
                    print("Deleted log: \(log.type) at \(log.mileage) miles")
                }
            }
        }
        logs.remove(atOffsets: offsets)
    }
}
