//
//  TripDetailView.swift
//  P7-Countries-Travel
//
//  Created by Antonio Gargiulo on 3/2/26.
//

import SwiftUI

struct TripDetailView: View {
    
    //@Observed since already init this viewmodel
    @ObservedObject var vm: AllTripsViewModel // just need for the update function
    @ObservedObject var tripEntity: TripEntity

    @Binding var selectedTrip: TripEntity?
    
    // Trip Entity - city, country, imageURL, Des
    @State var cityTextField: String = ""
    @State var tripDesc: String = ""
    @State var imageURL: String? = nil
    @State var imageURLTextField: String = ""

    init(tripEntity: TripEntity, vm: AllTripsViewModel, selectedTrip: Binding<TripEntity?>) {
        self.tripEntity = tripEntity
        self.cityTextField = tripEntity.tripCity ?? ""
        self.tripDesc = tripEntity.tripDesc ?? ""
        self.imageURL = tripEntity.tripImageURL
        self.vm = vm
        self._selectedTrip = selectedTrip
    }
    
    
    var body: some View {
        
        NavigationStack {
            ScrollView {
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
                    
                    tripImage
                    
                    
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
                            // clear dictionary for this key : image pair
                            vm.tripImages.removeValue(forKey: tripEntity.objectID)
                            // delete file FM
                            vm.deleteImageFromFM(for: tripEntity)
                            imageURLTextField = ""
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    
                    textEditorDesc
                    Text(tripEntity.tripImageURL ?? "No Image")
                    Spacer()
                    
                }
                .padding(.horizontal)
                .navigationTitle("Your Trip")
                .toolbar {
                    
                    ToolbarItem(placement: .navigationBarLeading) {
                        XMarkButton()
                    }
                    
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Update Trip") {
                            // Function to Update to CD - only reason we observed the VM
                            vm.updateCoreDataEntity(
                                entity: tripEntity,
                                newCity: cityTextField,
                                newDesc: tripDesc,
                                newImageURL: imageURL ?? ""
                            )
                            selectedTrip = nil
                            vm.getTripImage(for: tripEntity)
                        }
                    }
                    
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button("Delete Trip") {
                            // Function to Update to CD - onyl reason we observed the VM
                            vm.deleteSingleEntityFromCoreData(entity: tripEntity)
                            vm.deleteImageFromFM(for: tripEntity) // and Dict
                            selectedTrip = nil
                        }
                        .foregroundStyle(Color(.systemRed))
                    }
                    
                    
                    
                }
            } // End ScrollVuew
            .scrollDismissesKeyboard(.interactively)
            .onTapGesture {
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            }
        }


        
    }
    
    
}

#Preview {
    TripDetailView(tripEntity: DevPreview.previewTrip, vm: AllTripsViewModel(), selectedTrip: .constant(DevPreview.previewTrip))
}

extension TripDetailView {
    
    var tripImage : some View {
        ZStack {
            if imageURL == nil || imageURL == "" {
                Image("default")
                    .resizable()
                    .frame(height: 300)
                    .scaledToFit()
                    .cornerRadius(10)
            } else if let image = vm.tripImages[tripEntity.objectID] {
                Image(uiImage: image)
                    .resizable()
                    .frame(height: 300)
                    .scaledToFit()
                    .cornerRadius(10)
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
        }
    }
    
    var textEditorDesc: some View {
        TextEditor(text: $tripDesc)
            .frame(height: 150)
            .scrollContentBackground(.hidden)
            .padding(8)
            .background(Color(.systemGray6))
            .cornerRadius(10)
    }
}
