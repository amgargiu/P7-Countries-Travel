//
//  TripDetailView.swift
//  P7-Countries-Travel
//
//  Created by Antonio Gargiulo on 3/2/26.
//

import SwiftUI

struct TripDetailView: View {
    
    @ObservedObject var vm: AllTripsViewModel
    let tripEntity: TripEntity

    // Trip Entity - city, country, imageURL, Desc
    
    @State var cityTextField: String = ""
    @State var tripDesc: String = ""

    @State var imageURL: String? = nil
    @State var imageURLTextField: String = ""

    init(tripEntity: TripEntity, vm: AllTripsViewModel) {
        self.tripEntity = tripEntity
        self.cityTextField = tripEntity.tripCity ?? ""
        self.tripDesc = tripEntity.tripDesc ?? ""
        self.imageURL = tripEntity.tripImageURL
        self.vm = vm
    }
    
    
    var body: some View {
        
        NavigationStack {
            VStack (alignment: .leading) {
                
                HStack {
                    Text("Country:")
                        .bold()
                    Text(tripEntity.tripCountry ?? "")
                }
                TextField("What City?", text: $cityTextField)
                    .foregroundStyle(.secondary)
                    .padding(.horizontal,10)
                    .background(
                        Capsule()
                            .fill(Color(.systemGray6))
                    )

                
                
                if imageURL == nil || imageURL == "" {
                    Image("default")
                        .resizable()
                        .frame(height: 300)
                        .scaledToFit()
                        .cornerRadius(10)
                        .padding()
                } else {
                    let url = URL(string: imageURL ?? "")
                    AsyncImage(url: url) { image in
                        image
                            .resizable()
                            .frame(height: 300)
                            .scaledToFit()
                            .cornerRadius(10)
                    } placeholder: {
                        ProgressView()
                    }
                }
                
                HStack {
                    TextField("Cover Photo URL", text: $imageURLTextField)
                        .foregroundStyle(.secondary)
                        .padding(.horizontal,5)
                        .background(
                            Capsule()
                                .fill(Color(.systemGray6))
                        )
                    
                    
                    Button("Update Photo") {
                        imageURL = imageURLTextField
                        imageURLTextField = ""
                    }
                    .buttonStyle(.borderedProminent)
                }
                
                
                TextEditor(text: $tripDesc)
                    .frame(height: 150)
                    .scrollContentBackground(.hidden)
                    .padding(8)
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                
                Text(tripEntity.tripImageURL ?? "No Image")
                
                Spacer()
                
            }
            .padding(.horizontal)
            .navigationTitle("Your Trip")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Update Trip") {
                        // Function to Update to CD
                        vm.update(
                            entity: tripEntity,
                            newCity: cityTextField,
                            newDesc: tripDesc,
                            newImageURL: imageURL ?? ""
                        )
                        vm.refreshData()
                    }
                }
            }
        }


        
    }
    
    
}

#Preview {
    TripDetailView(tripEntity: DevPreview.previewTrip, vm: AllTripsViewModel())
}
