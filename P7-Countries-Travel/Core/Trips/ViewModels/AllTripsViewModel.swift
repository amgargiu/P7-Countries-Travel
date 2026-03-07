//
//  AllTripsViewModel.swift
//  P7-Countries-Travel
//
//  Created by Antonio Gargiulo on 3/2/26.
//

import Foundation
import Combine
import SwiftUI
import CoreData

class AllTripsViewModel: ObservableObject {
    
    // need @Published to loop on view for all trips that exit is coredata
    // I am storing the country ID - may need to sub to all countries to get the country info on the view?
    // Need to use core data to be able to delete or update a existing trip
    
    
    @Published var trips: [TripEntity] = [] // Array fo All Core Data Entities - update w/ sub to CD File
    
    @Published var tripImages: [NSManagedObjectID: UIImage] = [:] // Dictionary fro Trip Images
    @Published var tripFlagImages: [String : UIImage] = [:] // Dictionary fro Trip Images

    
    private let tripsDataService = TripsDataService.shared // the CoreData class
    var cancellables: Set<AnyCancellable> = []
    
    let fileManager = LocalFileManager.instance // FM
    let tripImageFolderName: String = "trip_images"
    let FlagImageFolderName: String = "trip_flag_images"

    
    init() {
        addSub()
        tripsDataService.fetchData() // just force a refresh each time
        let count = fileManager.fileCount(folderName: "trip_images")
            print("Files stored:", count)
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
    
    func clearAllTripsFromCoreData() {
        tripsDataService.deleteAllTrips()
    }
    
    func updateCoreDataEntity(entity: TripEntity, newCity: String, newDesc: String, newImageURL: String) {
        
        let oldURL = entity.tripImageURL // before updating store URL that was in the entiy passed in (whether it change or not)
        
        tripsDataService.update(entity: entity, newCity: newCity, newDesc: newDesc, newImageURL: newImageURL)
        
        // If image URL DID Change - enter closure where -
        /*
         1 - get the file name (objectID from core data) that was save to FM with
         2 - delete it from FM
         3 - remove it from the dictionary
         4 - call that getImage() func for that entity we just updated
         */
            if oldURL != newImageURL {

                // IF URL is new - go to the image saved for this entity and delete it from FM
                let imageName = entity.objectID.uriRepresentation().lastPathComponent
                fileManager.delete(
                    imageName: imageName,
                    folderName: tripImageFolderName
                )
                print("New URL, deleted old image")


                tripImages.removeValue(forKey: entity.objectID) // if image URL is changed - delete key for that image in Dict. Caal getTripImage again to reset that up for new image

                getTripImage(for: entity)
            }
    }
    
    
    func deleteSingleEntityFromCoreData(entity: TripEntity) {
        tripsDataService.delete(entity: entity)
        print("deleted trip entity")

    }
    
    
    // File Manager Funcs
    
    func getTripImage(for trip: TripEntity) {

        guard !trip.tripImageURL!.isEmpty else {
            print("no image to download")
            return
        }
        
        let imageName = trip.objectID.uriRepresentation().lastPathComponent
        
        // 1️⃣ Check FileManager
        if let savedImage = fileManager.get(
            imageName: imageName,
            folderName: tripImageFolderName
        ) {
            tripImages[trip.objectID] = savedImage
            print("found image in FM and set to Dic")

            return
        } else {
            // 2️⃣ Otherwise download
            print("downloading trip image")
            downloadTripImage(for: trip)
        }
        
    }
    
    
    func downloadTripImage(for trip: TripEntity) {

        guard
            let urlString = trip.tripImageURL,
            let url = URL(string: urlString)
        else { return }

        let imageName = trip.objectID.uriRepresentation().lastPathComponent

        URLSession.shared.dataTaskPublisher(for: url)
            .map { output -> UIImage? in
                return UIImage(data: output.data)
            }
            .receive(on: DispatchQueue.main)
            .sink { completion in
                if case .failure(let error) = completion {
                    print("Image download error:", error)
                }
            } receiveValue: { [weak self] image in

                guard
                    let self = self,
                    let image = image
                else { return }

                // Save to FileManager
                fileManager.save(
                    image: image,
                    imageName: imageName,
                    folderName: self.tripImageFolderName
                )
                print("saved image:", imageName)

                // Store in dictionary (auto refresh UI)
                self.tripImages[trip.objectID] = image
            }
            .store(in: &cancellables)
    }
    
    func deleteImageFromFM(for trip: TripEntity) {
        let imageName = trip.objectID.uriRepresentation().lastPathComponent
        fileManager.delete(imageName: imageName, folderName: tripImageFolderName)
        print("deleted image:", imageName)
        
        // Also Removing from Dictionary here
        tripImages.removeValue(forKey: trip.objectID)
        print("removed single key from in-memory dictionary")
    }
    
    func clearAllTripImages() { // From FM and Dictionary
        
        // 1️⃣ delete images from FileManager
        fileManager.deleteFolder(folderName: self.tripImageFolderName)
        print("deleted image folder from FM")
        // 2️⃣ clear in-memory dictionary
        tripImages.removeAll()
        print("clear in-memory dictionary")

    }
    
    
    func loopThroughAllTripEntities() {
        print("running loop func")
        for trip in trips {
            print("trip: \(trip.tripCountry ?? "")")
            
            guard let imageName = trip.tripCountry else { return }
            
            if let savedImage = fileManager.get(
                imageName: imageName,
                folderName: FlagImageFolderName
            ) {
                // found saved image - put it in the dictionary
                tripFlagImages[imageName] = savedImage
                return
            } else {
                downloadTripFlagImage(for: trip)
            }
            
            
        }
    }
    
    func downloadTripFlagImage(for trip: TripEntity) {
        
        guard let imageName = trip.tripCountry else { return }
        guard let url = URL(string: "https://example.com/\(imageName).png") else { return }
        
        URLSession.shared.dataTaskPublisher(for: <#T##URL#>)
        
    }
    
    
    
    
}
