//
//  Route.swift
//  P7-Countries-Travel
//
//  Created by Antonio Gargiulo on 3/4/26.
//

import Foundation

enum Route: Hashable {
    case selectCountry
    case newTrip(CountryModel)
    case allTrips
}
