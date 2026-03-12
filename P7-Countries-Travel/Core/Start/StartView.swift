//
//  StartView.swift
//  P7-Countries-Travel
//
//  Created by Antonio Gargiulo on 2/21/26.
//

import SwiftUI


struct StartView: View {
    
    @StateObject var vm = StartViewModel()
    
    @State private var urlString: String = ""
    @State private var indexCount = 0
    @State private var scale: CGFloat = 1.0
    
    
    let timer = Timer.publish(every: 5, on: .main, in: .common).autoconnect()
    
    @State private var path: [Route] = []
 
    
    var body: some View {
        
        NavigationStack(path: $path) {
            ZStack {
                
                Color.black.ignoresSafeArea()
                
                backgroundImageLogic
                
                VStack (spacing: 5) {
                    buttons
                    buttonNames
                }
                .navigationDestination(for: Route.self) { route in
                    switch route {
                    case .selectCountry:
                        CountryListView(path: $path)

                    case .newTrip(let country):
                        NewTripView(country: country, path: $path)

                    case .allTrips:
                        AllTripsView(path: $path)
                    }
                }
            } // End ZStack
            .onAppear{
                // Using to reset to same image order when leave and go back to screen...
                // Helps for some reason image zoom is off when we dont reset to 1st image
                indexCount = 0
                urlString = vm.startImageURLs[indexCount]
            }
            .onReceive(timer) { _ in
                // Moving to next image
                // 2. Now it is safe to do the math
                indexCount = (indexCount + 1) % vm.startImageURLs.count
                // 1. Update urlString through indexCount - helps ASYNCIMAGE
                urlString = vm.startImageURLs[indexCount]
            }
                
        }
    }
}


#Preview {
    NavigationStack {
        StartView()
    }
}


extension StartView {
    
    
    var buttonNames: some View {
        HStack (spacing: 40) {
            Text("Create Trip")
                .font(.subheadline)
                .foregroundStyle(.white)
                .bold()
                .scaleEffect(1.2)
                .offset(x: -10)
            Text("My Trips")
                .font(.subheadline)
                .foregroundStyle(.white)
                .bold()
                .scaleEffect(1.2)
                .offset(x: 10)
        }
    }
    
    var buttons : some View {
        HStack (spacing: 50) {
            
            Button {
                path.append(.selectCountry)
            } label: {
                CircleButtonView(iconName: "plus.app.fill")
                    .scaleEffect(1.5)
            }
            
            Button {
                path.append(.allTrips)
            } label: {
                CircleButtonView(iconName: "airplane.up.right.app")
                    .scaleEffect(1.5)
            }
        }
        .background(
            Capsule()
                .fill(.ultraThinMaterial)
        )
    }
    
    var backgroundImageLogic: some View {
        ZStack {
            if vm.downloadedImages.indices.contains(indexCount) {
                if let image = vm.downloadedImages[indexCount] {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .scaleEffect(scale)
                        .ignoresSafeArea()
                    // 1. This ensures a smooth zoom restarts every time the ID changes
                        .onAppear {
                            scale = 1.0
                            // Dome delay to allows image to render first at regular scale before zooming
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                                withAnimation(.linear(duration: 5)) {
                                    scale = 1.2
                                }
                            }
                        }
                        .id(indexCount)
                }
            } else {
                AsyncImage(url: URL(string: urlString)) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                            .scaleEffect(scale)
                            .ignoresSafeArea()
                        // 1. This ensures a smooth zoom restarts every time the ID changes
                            .onAppear {
                                scale = 1.0
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                                    withAnimation(.linear(duration: 5)) {
                                        scale = 1.2
                                    }
                                }
                            }
                    default:
                        // While loading next image, show a black screen or simple color
                        // This prevents the "jumping" ProgressView
                        Color.black.ignoresSafeArea()
                    }
                }
                // 2. This is the "Magic Trick": transition + id
                .id(urlString) // The async image is the same - cant really have the onappear trigger without telling it a different url string is new item
                .transition(.opacity.animation(.easeInOut(duration: 1)))
            } // End IF
        } // end ZStack
    }
    
}
