//
//  CountryFlagDataService.swift
//  P7-Countries-Travel
//
//  Created by Antonio Gargiulo on 2/21/26.
//

import Foundation
import SwiftUI
import Combine


class CountryFlagDataService {
    
    @Published var countryFlagPNG : UIImage? = nil
    private let country : CountryModel
    var cancellables: Set<AnyCancellable> = []
    
    let cacheManager = CacheManager.instance
    let imageCacheKey: String
    let imageURL : String
    
    
    
    init(country: CountryModel) {
        self.country = country
        self.imageCacheKey = "\(country.id)"
        self.imageURL = country.flags?.png ?? ""
        getFlagImage()
    }
    
    
    private func getFlagImage()  {
        
        if let image = cacheManager.get(key: imageCacheKey) {
            self.countryFlagPNG = image
            print("got from cache")
        } else {
            downloadImageData()
            print("downloading flag image")
        }
        
    }
    
    
    
    private func downloadImageData() {
        
        guard let url = URL(string: imageURL) else { return }
        
        URLSession.shared.dataTaskPublisher(for: url)
            .subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: DispatchQueue.main)
            .tryMap { (data, response) -> UIImage? in
                guard
                    let response = response as? HTTPURLResponse,
                        response.statusCode >= 200 && response.statusCode < 300
                else {
                    throw URLError(.badServerResponse)
                }
                
                return UIImage(data: data) ?? nil
            }
            .sink(receiveCompletion: NetworkingManager.handleSinkCompletion, receiveValue: { [weak self] receivedImageData in
                guard let receivedImageData = receivedImageData else { return }
                guard let imageCacheKey = self?.imageCacheKey else { return }
                self?.countryFlagPNG = receivedImageData
                self?.cacheManager.add(key: imageCacheKey, image: receivedImageData) // adding to cache
                print("added to cache")
            })
            .store(in: &cancellables)
        
    }
    
    
    
}
