//
//  HomeView.swift
//  P7-Countries-Travel
//
//  Created by Antonio Gargiulo on 2/21/26.
//

import SwiftUI

struct CountryListView: View {
    
    @StateObject var vm = CountryListViewModel()
    
    var body: some View {


        VStack {
            SearchBarView(textfieldText: $vm.searchText)
            .padding()
            
            HStack {
                Text("Flag")
                    .offset(x: 30)
                Spacer()
                Text("Country")
                Spacer()
                Spacer()
                Text("Population & Capital")
                    .offset(x: -20)
            }
            .foregroundStyle(.secondary)

            List {

                ForEach(vm.allCountries) { country in
                    if country.population != 0 {
                        NavigationLink(value: country) {
                            CountryRowView(country: country)
                        }
                        
                    }
                }
            }
            .listStyle(PlainListStyle())
        }
        .navigationTitle(Text("Which Country?"))
        .navigationDestination(for: CountryModel.self) { country in
            NewTripView(country: country)
        }
        
    }
}

#Preview {
    NavigationStack {
        CountryListView()
            .environmentObject(DevPreview.vm)
    }
}
