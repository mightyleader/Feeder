//
//  FirstRunSheet.swift
//  Feeder
//
//  Created by Rob Stearn on 28/11/2024.
//

import SwiftUI
import SwiftData

struct FirstRunSheet: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) var dismiss
    @State var birthDate: Date = .now
    @State var birthWeight: String = "3000"
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button {
                    self.dismiss()
                } label: {
                    Label("Skip", systemImage: "xmark")
                }
                .tint(.green)
                .padding()
            }
            // cake image
            Image(systemName: "birthday.cake.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 200, height: 200)
                .scaledToFill()
                .padding()
                .foregroundStyle(.green)
            // congrats
            Text("Congratulations!")
                .font(.title)
                .fontWeight(.bold)
            //instructions
            Text("Log the birth date, time and weight of your baby below.")
                .font(.body)
                .foregroundStyle(.gray)
                .multilineTextAlignment(.center)
            Spacer()
            //date/time picker
            DatePicker("Birth date",
                       selection: $birthDate,
                       displayedComponents: [.date, .hourAndMinute])
            .datePickerStyle(.automatic)
            .fontWeight(.heavy)
            .padding()
            
            HStack {
                //weight picker
                Text("Weight ")
                    .font(.body)
                    .fontWeight(.heavy)
                    .frame(alignment: .trailing)
                    .tint(.secondary)
                TextField("Weight", text: $birthWeight)
                #if os(iOS)
                    .keyboardType(.numberPad)
                #endif
                    .frame(alignment: .trailing)
                    .font(.title)
                    .fontWeight(.heavy)
                    .tint(.primary)
                    .border(.tertiary)
                    .textFieldStyle(.roundedBorder)
                    .multilineTextAlignment(.trailing)
                Text(" grams")
                    .font(.body)
                    .fontWeight(.heavy)
                    .frame(alignment: .leading)
                    .tint(.secondary)
            }
            .padding()
            
            Button("Save") {
                self.saveBirthDetails()
                self.dismiss()
            }
            .font(.headline)
            .fontWeight(.heavy)
            .buttonStyle(.borderedProminent)
            .foregroundStyle(.white)
            .tint(.green)
            Spacer()
        }
    }
    
    private func saveBirthDetails() {
        let newItem = Weight(weight: Double(birthWeight) ?? 0.0, type: .birthWeight, date: birthDate)
        modelContext.insert(newItem)
        UserDefaults.standard.set(true, forKey: "firstRunBirthWeightLogged")
        print ("Birth Weight First Run Log status saved to UserDefaults.")
        self.dismiss()
    }
}

#Preview {
    FirstRunSheet()
}
