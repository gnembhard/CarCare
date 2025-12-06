//
//  CarListView.swift
//  CarCare
//
//  Created by Giovanni Nembhard on 11/27/25.
//

import SwiftUI
import FirebaseAuth

struct CarListView: View {
    @State private var cars: [Car] = []
    private let carService = CarService()

    var body: some View {
        NavigationView {
            ZStack {
                Color(.systemGroupedBackground).ignoresSafeArea()

                VStack {
                    if cars.isEmpty {
                        // Empty state
                        VStack(spacing: 15) {
                            Image(systemName: "car.2.fill")
                                .font(.system(size: 60))
                                .foregroundColor(.gray)

                            Text("No Cars Added")
                                .font(.title3)
                                .bold()
                                .foregroundColor(.secondary)

                            Text("Tap the + button to add your first car.")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        .padding(.top, 100)
                    } else {
                        // Car list with card styling
                        List {
                            ForEach(cars) { car in
                                NavigationLink(destination: CarDetailView(car: car)) {
                                    CarRowCard(car: car)
                                }
                                .listRowSeparator(.hidden)
                            }
                        }
                        .listStyle(.plain)
                    }
                }
            }
            .navigationTitle("CarCare")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: AddCarView()) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2) // Slightly smaller, cleaner
                            .foregroundColor(.accentColor) // Uses app accent color
                    }
                }
            }
            .onAppear {
                if let userId = Auth.auth().currentUser?.uid {
                    carService.getCars(for: userId) { list in
                        cars = list
                    }
                }
            }
        }
    }
}

struct CarRowCard: View {
    let car: Car

    var body: some View {
        HStack(spacing: 16) {
            // Car image or placeholder
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.blue.opacity(0.15))

                if let urlString = car.imageURL, let url = URL(string: urlString) {
                    AsyncImage(url: url) { phase in
                        switch phase {
                        case .empty:
                            ProgressView()
                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFit()
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                        case .failure:
                            Image(systemName: "car.fill")
                                .font(.system(size: 30))
                                .foregroundColor(.blue)
                        @unknown default:
                            Image(systemName: "car.fill")
                                .font(.system(size: 30))
                                .foregroundColor(.blue)
                        }
                    }
                } else {
                    Image(systemName: "car.fill")
                        .font(.system(size: 30))
                        .foregroundColor(.blue)
                }
            }
            .frame(width: 60, height: 60)

            VStack(alignment: .leading, spacing: 4) {
                Text("\(String(car.year)) \(car.make) \(car.model)")
                    .font(.headline)

                Text("Mileage: \(car.mileage) mi")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }

            Spacer()

            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
        }
        .padding(10)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
        )
    }
}
