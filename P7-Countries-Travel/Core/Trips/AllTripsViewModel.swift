//
//  AllTripsViewModel.swift
//  P7-Countries-Travel
//
//  Created by Antonio Gargiulo on 3/2/26.
//

import Foundation
import Combine

class AllTripsViewModel: ObservableObject {
    
    // need @Published to loop on view for all trips that exit is coredata
    // I am storing the country ID - may need to sub to all countries to get the country info on the view?
    // Need to use core data to be able to delete or update a existing trip
    
    
    @Published var trips: [TripEntity] = []
    
    private let tripsDataService = TripsDataService.shared
    var cancellables: Set<AnyCancellable> = []
    
    init() {
        addSub()
        tripsDataService.fetchData()
    }
    
    func addSub() {
        tripsDataService.$savedEntities
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] savedEntities in
                self?.trips = savedEntities
            })
            .store(in: &cancellables)
    }
    
    
    // Core Data funcs
    func clearAllTrips() {
        tripsDataService.deleteAllTrips()
    }
    
    func update(entity: TripEntity, newCity: String, newDesc: String, newImageURL: String) {
        tripsDataService.update(entity: entity, newCity: newCity, newDesc: newDesc, newImageURL: newImageURL)
    }
    
    func refreshData() {
        tripsDataService.fetchData()
    }
    
    
    
    
}
