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
    
    enum Route: Hashable {
        case home
        case contentView
    }
    
    
    let timer = Timer.publish(every: 5, on: .main, in: .common).autoconnect()
    
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            
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
            }
            
            
            
            
            
            
            
            //            Image(uiImage:vm.downloadedImages[0])
            
            NavigationLink(destination: ContentView()) {
                Text("ffff")
                    .foregroundStyle(Color.white)
            }
            
            VStack (spacing: 5) {
                
                
                HStack (spacing: 50) {
                    
                    
                    NavigationLink(value: Route.home) {
                        CircleButtonView(iconName: "plus.app.fill")
                            .scaleEffect(1.5)
                    }
                    
                    
                    NavigationLink(value: Route.contentView) {
                        CircleButtonView(iconName: "airplane.up.right.app")
                            .scaleEffect(1.5)
                    }
                    
                    
                }
                .background(
                    Capsule()
                        .fill(.ultraThinMaterial)
                )
                
                
                HStack (spacing: 50) {
                    Text("Create Trip")
                        .font(.subheadline)
                        .foregroundStyle(.white)
                        .bold()
                        .scaleEffect(1.2)
                    Text("My Trips")
                        .font(.subheadline)
                        .foregroundStyle(.white)
                        .bold()
                        .scaleEffect(1.2)
                        .offset(x: 10)
                }
                
            }
            .onAppear{
                urlString = vm.startImageURLs[indexCount]
                indexCount = 0
            }
            .navigationDestination(for: Route.self) { route in
                switch route {
                case .home: CountryListView()
                case .contentView: AllTripsView()
                }
                
                
            } // End ZStack
            .onReceive(timer) { _ in
                // 3. Move to next image
                // 1. Check if the array has anything in it first
                guard !vm.downloadedImages.isEmpty else { return }
                
                // 2. Now it is safe to do the math
                indexCount = (indexCount + 1) % vm.startImageURLs.count
                
                // Update urlString through indexCount - helps ASYNCIMAGE
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
