//
//  HomeViewModel.swift
//  P7-Countries-Travel
//
//  Created by Antonio Gargiulo on 2/21/26.
//

import Foundation
import Combine


class CountryListViewModel: ObservableObject {
    
    @Published var allCountries: [CountryModel] = []
    let countryDataService = CountryDataService()
    
    @Published var searchText: String = ""
    
    var cancellables: Set<AnyCancellable> = []
    
    init() {
        addSubs()
    }
    
    
    func addSubs() {
        
        countryDataService.$allCountries
            .combineLatest($searchText)
            .map(mapResultingArray)
            .sink { returnedArray in
                self.allCountries = returnedArray
            }
            .store(in: &cancellables)
    }
    
    
    func mapResultingArray(countries: [CountryModel], searchText: String) -> [CountryModel] {
        if searchText.isEmpty {
            return countries
        } else {
            let lowercaseText = searchText.lowercased()
            return countries.filter { country in
                let name = country.name?.common?.lowercased() ?? ""
                return name.contains(lowercaseText)
            }
        }
    }
    
    
}
