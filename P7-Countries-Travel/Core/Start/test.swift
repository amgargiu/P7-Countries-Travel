//
//  test.swift
//  P7-Countries-Travel
//
//  Created by Antonio Gargiulo on 2/22/26.
//

import SwiftUI

struct test: View {
    
    @StateObject var vm = StartViewModel()
    
    var body: some View {
        ScrollView {
            VStack {
                
                if let firstImage = vm.downloadedImages.first {
                    Image(uiImage: firstImage ?? UIImage())
                        .resizable()
                        .scaledToFit()
                        .ignoresSafeArea()
                } else {
                    ProgressView() // loading state
                }
                
                let URL = URL(string: "https://cdn.britannica.com/61/93061-050-99147DCE/Statue-of-Liberty-Island-New-York-Bay.jpg")!
                AsyncImage(url: URL)
            }
        }
    }
}

#Preview {
    test()
}
