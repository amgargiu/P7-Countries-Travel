//
//  NewTripView.swift
//  P7-Countries-Travel
//
//  Created by Antonio Gargiulo on 2/22/26.
//

import SwiftUI

struct NewTripView: View {
    
    
    @StateObject var vm = NewTripViewModel()
    
    let country: CountryModel

    
    // Trip Entity - city, country, imageURL, Desc
    
    @State var cityTextField: String = ""
    @State var newTripDesc: String = ""

    @State var inputURL: String? = nil
    @State var inputURLTextField: String = ""

    @Binding var path: [Route]   // 👈 THIS is required
    
    
    var body: some View {
        
        ScrollView {
            VStack (alignment: .leading) {
                
                HStack {
                    Text("Country:")
                        .bold()
                    Text(country.name?.common ?? "")
                }
                TextField("What City?", text: $cityTextField)
                    .foregroundStyle(.secondary)
                    .padding(.horizontal,10)
                    .background(
                        Capsule()
                            .fill(Color(.systemGray6))
                    )
                
                
                
                if inputURL == nil || inputURL == "" {
                    Image("default")
                        .resizable()
                        .frame(height: 300)
                        .scaledToFit()
                        .cornerRadius(10)
                } else {
                    let url = URL(string: inputURL ?? "")
                    AsyncImage(url: url) { image in
                        image
                            .resizable()
                            .frame(height: 300)
                            .frame(maxWidth: .infinity)
                            .scaledToFit()
                            .cornerRadius(10)
                    } placeholder: {
                        ProgressView()
                    }
                }
                
                HStack {
                    TextField("Cover Photo URL", text: $inputURLTextField)
                        .foregroundStyle(.secondary)
                        .padding(.horizontal,5)
                        .background(
                            Capsule()
                                .fill(Color(.systemGray6))
                        )
                    
                    
                    Button("Update Photo") {
                        inputURL = inputURLTextField
                        inputURLTextField = ""
                    }
                    .buttonStyle(.borderedProminent)
                }
                
                HStack {
                    Text("Capital:")
                        .bold()
                    Text(country.capital?.first ?? "No Capital")
                }
                .textSelection(.enabled)
                
                
                TextEditor(text: $newTripDesc)
                    .frame(height: 150)
                    .scrollContentBackground(.hidden)
                    .padding(8)
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                
                Spacer()
                
            }
            .padding(.horizontal)
            .navigationTitle("New Trip")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        // Function to ADD to CD
                        vm.addTrip(
                            tripCity: cityTextField,
                            tripCountry: country.id, // when we make a trip entity - put the country.id as the tripCountry - which is also what we use to Cache as key...
                            tripDesc: newTripDesc,
                            tripImageURL: inputURL ?? ""
                        )
                        // 👇 navigate programmatically
                        path = [.allTrips]
                    } // End button
                } // End Toolbar Item
                
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Nevermind") {
                        // 👇 navigate programmatically
                        path = []
                    } // End button
                } // End Toolbar Item
            }
        } // end ScrollView
        .scrollDismissesKeyboard(.interactively)
        .onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
                
    }
}

#Preview {
    
    NavigationStack {
        NewTripView(country: DevPreview.previewCountry, path: .constant([]))
    }
}
