//
//  CountryModel.swift
//  P7-Countries-Travel
//
//  Created by Antonio Gargiulo on 2/20/26.
//

import Foundation


//https://restcountries.com/

struct CountryModel: Codable, Identifiable, Hashable {
    let id: String
    let flags: Flags?
    let name: Name?
    let languages: [String: String]?
    let capital: [String]?
    let population: Int?

    
    enum CodingKeys: String, CodingKey {
            case id = "cca3" // Tell Swift: "Look for/use 'cca3' for the 'id' fields we added"
            case flags, name, languages, capital, population
        }
    
}


struct Flags: Codable, Hashable {
    let png: String?
    let svg: String?
    let alt: String?
}

struct Name: Codable, Hashable {
    let common, official: String?
}







