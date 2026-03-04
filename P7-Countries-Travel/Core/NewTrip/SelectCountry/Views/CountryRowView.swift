//
//  CountryRowView.swift
//  P7-Countries-Travel
//
//  Created by Antonio Gargiulo on 2/21/26.
//

import SwiftUI

struct CountryRowView: View {
    
    let country: CountryModel
    
    
    var body: some View {
        
        HStack(alignment: .center) {
            CountryFlagView(country: country)
                .frame(width: 50, height: 50)
            
            VStack (alignment: .leading) {
                Text(country.name?.common ?? "")
                    .font(.headline)
                Text(country.id)
                    .font(.subheadline)
            }
            
            Spacer()
            
            VStack (alignment: .trailing) {
                let pop = String(country.population ?? 0)
                Text(pop)
                    .font(.headline)
                Text(country.capital?.first ?? "No Capital")
                    .font(.subheadline)
            }
            .frame(maxWidth: UIScreen.main.bounds.width / 3, alignment: .trailing)
            
            
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal)
        
        
    }
}

#Preview {
    CountryRowView(country: DevPreview.previewCountry)
}
