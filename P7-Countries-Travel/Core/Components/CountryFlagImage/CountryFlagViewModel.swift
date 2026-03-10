//
//  CountryFlagViewModel.swift
//  P7-Countries-Travel
//
//  Created by Antonio Gargiulo on 2/21/26.
//

import Foundation
import SwiftUI
import Combine

class CountryFlagViewModel: ObservableObject {
    
    @Published var flagImage : UIImage?
    @Published var country: CountryModel
    private let countryFlagDataService: CountryFlagDataService // make private...
    
    
    var cancellables: Set<AnyCancellable> = []
    
    
    init(country: CountryModel) {
        self.country = country
        countryFlagDataService = CountryFlagDataService(country: country)
        addSub()
    }
    
    func addSub() {
        countryFlagDataService.$countryFlagPNG
            .sink(receiveValue: { [weak self] flagPNG in
                self?.flagImage = flagPNG
            })
            .store(in: &cancellables)
    }
    
    
}
