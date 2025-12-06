//
//  AddCarView.swift
//  CarCare
//
//  Created by Giovanni Nembhard on 11/27/25.
//

import SwiftUI
import FirebaseAuth

struct AddCarView: View {
    @Environment(\.dismiss) var dismiss
    @State private var make = ""
    @State private var model = ""
    @State private var year = ""
    @State private var mileage = ""
    @State private var oilCapacity = ""
    @State private var vin = ""
    @State private var errorText = ""
    
    private let service = FirestoreService()
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Group {
                    TextField("Make", text: $make)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    TextField("Model", text: $model)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    TextField("Year", text: $year)
                        .keyboardType(.numberPad)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    TextField("Mileage", text: $mileage)
                        .keyboardType(.numberPad)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    TextField("Oil Capacity (qt)", text: $oilCapacity)
                        .keyboardType(.decimalPad)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    HStack {
                        TextField("VIN (optional)", text: $vin)
                            .textInputAutocapitalization(.characters)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                        Button("Fetch from VIN") {
                            Task {
                                await fetchCarInfo(from: vin)
                            }
                        }
                        .buttonStyle(.bordered)
                        .disabled(vin.count != 17) // enable only for valid VIN length
                    }
                }
                .padding(.horizontal)
                
                if !errorText.isEmpty {
                    Text(errorText)
                        .foregroundColor(.red)
                }
                
                Button("Save Car") {
                    saveCar()
                }
                .buttonStyle(.borderedProminent)
                .padding(.top)
            }
            .padding(.top, 40)
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
    }
    
    // MARK: - Save car
    func saveCar() {
        guard let uid = Auth.auth().currentUser?.uid else {
            errorText = "Not logged in"
            return
        }
        
        guard let yearInt = Int(year) else {
            errorText = "Invalid year"
            return
        }
        
        guard let mileageInt = Int(mileage) else {
            errorText = "Invalid mileage"
            return
        }
        
        let oilDouble = Double(oilCapacity)
        
        let newCar = Car(
            make: make,
            model: model,
            year: yearInt,
            mileage: mileageInt,
            oilCapacity: oilDouble,
            userId: uid,
            vin: vin.isEmpty ? nil : vin
        )
        
        Task {
            do {
                try await service.addCar(newCar)
                dismiss()
            } catch {
                errorText = error.localizedDescription
            }
        }
    }
    
    // MARK: - Fetch car info from VIN
    func fetchCarInfo(from vin: String) async {
        guard vin.count == 17 else { return } // ensure valid VIN length
        let apiURL = "https://vpic.nhtsa.dot.gov/api/vehicles/DecodeVinValues/\(vin)?format=json"
        
        do {
            let (data, _) = try await URLSession.shared.data(from: URL(string: apiURL)!)
            if let decoded = try? JSONDecoder().decode(VinResponse.self, from: data),
               let result = decoded.Results.first {
                DispatchQueue.main.async {
                    self.make = result.Make ?? self.make
                    self.model = result.Model ?? self.model
                    self.year = result.ModelYear ?? self.year
                }
            }
        } catch {
            print("❌ VIN fetch failed: \(error.localizedDescription)")
        }
    }
}

// MARK: - VIN API Response Models
struct VinResponse: Codable {
    let Results: [VinResult]
}

struct VinResult: Codable {
    let Make: String?
    let Model: String?
    let ModelYear: String?
}
