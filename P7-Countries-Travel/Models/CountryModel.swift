//
//  CountryModel.swift
//  P7-Countries-Travel
//
//  Created by Antonio Gargiulo on 2/20/26.
//

import Foundation

// https://restcountries.com/
//"https://restcountries.com/v3.1/all?fields=name,flags,capital,languages,population,cca3"
/*
 {
   "flags": {
     "png": "https://flagcdn.com/w320/vn.png",
     "svg": "https://flagcdn.com/vn.svg",
     "alt": "The flag of Vietnam features a large five-pointed yellow star on a red field."
   },
   "name": {
     "common": "Vietnam",
     "official": "Socialist Republic of Vietnam",
     "nativeName": {
       "vie": {
         "official": "Cộng hòa xã hội chủ nghĩa Việt Nam",
         "common": "Việt Nam"
       }
     }
   },
   "languages": {
     "vie": "Vietnamese"
   },
   "capital": [
     "Hanoi"
   ],
   "population": 101343800
 }
 */

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







