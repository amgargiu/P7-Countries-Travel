//
//  CountryFlagView.swift
//  P7-Countries-Travel
//
//  Created by Antonio Gargiulo on 2/21/26.
//

import SwiftUI



struct CountryFlagView: View {
    
    @StateObject var vm : CountryFlagViewModel
    
    init(country: CountryModel) {
        _vm = StateObject(wrappedValue: CountryFlagViewModel(country: country))
    }
    
    
    var body: some View {
        ZStack {
            if let image = vm.flagImage {
                VStack {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                }
            } else {
                VStack {
                    Text(vm.country.id)
                    ProgressView()
                }
            }
            
        }
    }
}

#Preview {
    CountryFlagView(country: DevPreview.previewCountry)
}
