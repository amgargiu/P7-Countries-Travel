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
        VStack {
            if let firstImage = vm.downloadedImages.first {
                Image(uiImage: firstImage ?? UIImage())
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
            } else {
                ProgressView() // loading state
            }
        }
    }
}

#Preview {
    test()
}
