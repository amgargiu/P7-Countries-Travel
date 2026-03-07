//
//  NewTripViewModel.swift
//  P7-Countries-Travel
//
//  Created by Antonio Gargiulo on 3/2/26.
//

import Foundation


class NewTripViewModel: ObservableObject {
    
    // Doing this just to act as middleman for CoreData
    
    // Should this be a singleton - I will need this also for the current trips to update or delete?
    
    private let dataService = TripsDataService.shared
    
    func addTrip(tripCity: String, tripCountry: String, tripDesc: String, tripImageURL: String) {
        dataService.add(
            tripCity: tripCity, tripCountry: tripCountry, tripDesc: tripDesc, tripImageURL: tripImageURL)
    }
    
    
}
