//
//  TripListItemView.swift
//  P7-Countries-Travel
//
//  Created by Antonio Gargiulo on 3/2/26.
//

import SwiftUI

struct TripListItemView: View {
    
//    let tripEntity: TripEntity
    @ObservedObject var tripEntity: TripEntity // property wrapper to watch/observe state of object and redraw on change
    @ObservedObject var vm: AllTripsViewModel

    
    var body: some View {
        
        ZStack(alignment: .top) {
            
            // BACK CARD
            VStack {
                HStack(alignment: .top) {
                    VStack(alignment: .leading) {
                        Text(tripEntity.tripCountry ?? "")
                            .font(.headline)
                        Text(tripEntity.tripCity ?? "")
                            .font(.subheadline)
                    }
                    Spacer()
                    
                    
                    if let key = tripEntity.tripCountry,
                       let image = CacheManager.instance.get(key: key) {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50, height: 50)
                    }
                    
                    if let key = tripEntity.tripCountry,
                       let image = CacheManager.instance.get(key: key) {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50, height: 50)
                    }
                }
                .padding(.top, 40) // 👈 push content DOWN to make space for image
                .padding()
            }
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(.thinMaterial)
                    .shadow(color: Color.black.opacity(0.5), radius: 5)
            )
            
          
            
            // FRONT IMAGE (on top)
            if tripEntity.tripImageURL == "" {
                Image("default")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 200, height: 100)
                    .clipShape(Capsule())
                    .offset(x: -40, y: -50)
                    .shadow(color: Color.black, radius: 5)
            } else if let image = vm.tripImages[tripEntity.objectID] {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 200, height: 100)
                    .clipShape(Capsule())
                    .offset(x: -40, y: -50)
                    .shadow(color: Color.black, radius: 5)
            } else {
                AsyncImage(
                    url: URL(string: tripEntity.tripImageURL ?? "")
                ) { image in
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: 200, height: 100)
                        .clipShape(Capsule())
                        .offset(x: -40, y: -50)
                        .shadow(color: Color.black, radius: 5)
                } placeholder: {
                    ProgressView()
                }
            }
            
            
        }
        .frame(width: 300)
        .padding()
        .onAppear {
            vm.getTripImage(for: tripEntity)
        }

        
    }
}

#Preview {
    ZStack {
        Color.red
        VStack {
            Spacer()
            TripListItemView(tripEntity: DevPreview.previewTrip, vm: AllTripsViewModel())
            Spacer()
            TripListItemView(tripEntity: DevPreview.previewTripEmptyURL, vm: AllTripsViewModel())
        }
    }
    
}
