//
//  DevPreview.swift
//  P7-Countries-Travel
//
//  Created by Antonio Gargiulo on 2/21/26.
//

import Foundation


class DevPreview {
    
    // Sample Country for preview provider
    static let previewCountry = CountryModel(
        id: "ZAF", // Using the cca3 code as the ID
        flags: Flags(
            png: "https://flagcdn.com/w320/za.png",
            svg: "https://flagcdn.com/za.svg",
            alt: "The flag of South Africa is composed of two equal horizontal bands of red and blue..."
        ),
        name: Name(
            common: "South Africa",
            official: "Republic of South Africa"
        ),
        languages: [
            "afr": "Afrikaans",
            "eng": "English",
            "zul": "Zulu"
        ],
        capital: ["Pretoria", "Bloemfontein", "Cape Town"],
        population: 63100945
    )
    
    // sample HomeViewModel instance
    static let vm = CountryListViewModel()
    
    
    static let previewTrip: TripEntity = {
        let context = TripsDataService.shared.context
        
        let trip = TripEntity(context: context)
        trip.tripCity = "Rome"
        trip.tripCountry = "ITA"
        trip.tripDesc = "Colosseum trip we going on"
        trip.tripImageURL = "https://cdn.mos.cms.futurecdn.net/BiNbcY5fXy9Lra47jqHKGK.jpg"
        
        return trip
    }()
    
    static let previewTripEmptyURL: TripEntity = {
        let context = TripsDataService.shared.context
        
        let trip = TripEntity(context: context)
        trip.tripCity = "Rome"
        trip.tripCountry = "ITA"
        trip.tripDesc = "Colosseum trip we going on"
        trip.tripImageURL = ""
        
        return trip
    }()
    
}
