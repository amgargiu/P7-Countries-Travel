//
//  TripListItemView.swift
//  P7-Countries-Travel
//
//  Created by Antonio Gargiulo on 3/2/26.
//

import SwiftUI

struct TripListItemView: View {
    
//    let tripEntity: TripEntity
    @ObservedObject var tripEntity: TripEntity
    
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
                    .scaledToFit()
                    .clipShape(Capsule())
                    .frame(width: 300, height: 200)
                    .padding(.top, -150)
            } else {
                AsyncImage(
                    url: URL(string: tripEntity.tripImageURL ?? "")
                ) { image in
                    image
                        .resizable()
                        .scaledToFit()
                        .clipShape(Capsule())
                        .frame(width: 300, height: 200)
                } placeholder: {
                    ProgressView()
                }
                .padding(.top, -150)
            }
            
            
        }
        .frame(width: 300)
        .padding()

        
    }
}

#Preview {
    ZStack {
        Color.red
        TripListItemView(tripEntity: DevPreview.previewTrip)
    }
    
}
