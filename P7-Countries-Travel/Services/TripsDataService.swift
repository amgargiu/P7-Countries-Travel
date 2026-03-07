//
//  TripsDataService.swift
//  P7-Countries-Travel
//
//  Created by Antonio Gargiulo on 3/1/26.
//

import Foundation
import CoreData

class TripsDataService {
    
    @Published var savedEntities: [TripEntity] = []
    
    static let shared = TripsDataService()
    let container: NSPersistentContainer
    var context: NSManagedObjectContext {
        container.viewContext
    }
    
    init() {
        container = NSPersistentContainer(name: "TripContainer")
        container.loadPersistentStores { data, error in
            if let error = error {
                print("Unable to load Core Data persistent stores: \(error)")
            }
        }
    }
    
    // get request NSFetch
    func fetchData() {
        let request = NSFetchRequest<TripEntity>(entityName: "TripEntity")

        do {
            savedEntities = try container.viewContext.fetch(request)
        } catch let error {
            print("error fetching \(error)")
        }
    }
    
    //add new TripEntity from a TripModel...?
    func add(tripCity: String, tripCountry: String, tripDesc: String, tripImageURL: String) {
        let newEntity = TripEntity(context: container.viewContext)
        newEntity.tripCity = tripCity
        newEntity.tripCountry = tripCountry
        newEntity.tripDesc = tripDesc
        newEntity.tripImageURL = tripImageURL
        saveAndRefresh()
    }
    
    //update existing TripEntity
    func update(entity: TripEntity, newCity: String, newDesc: String, newImageURL: String) {
        entity.tripCity = newCity
        entity.tripDesc = newDesc
        entity.tripImageURL = newImageURL
        saveAndRefresh()
    }
    
    //delete existing TripEntity
    func delete(entity: TripEntity) {
        container.viewContext.delete(entity)
        saveAndRefresh()
    }
    
    
    // save
    func save() {
        do {
            try container.viewContext.save()
        } catch let error {
            print("error saving \(error)")
        }
    }
    
    func saveAndRefresh() {
        save()
        fetchData()
    }
    
    func deleteAllTrips() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = TripEntity.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try container.viewContext.execute(deleteRequest)
            print("Batch Deleting Trip Entities")
            saveAndRefresh()
        } catch let error {
            print("Error deleting all trips: \(error)")
        }
    }
    
    
    
    
}
