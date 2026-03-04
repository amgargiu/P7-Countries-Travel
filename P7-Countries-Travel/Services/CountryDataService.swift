//
//  CountryDataService.swift
//  P7-Countries-Travel
//
//  Created by Antonio Gargiulo on 2/21/26.
//

import Foundation
import Combine

class CountryDataService {
    
    @Published var allCountries: [CountryModel] = []
    
    var cancellables: Set<AnyCancellable> = []
    
    
    init() {
        
        getData()
    }
    
    
    func getData() {
        
        guard let url = URL(string: "https://restcountries.com/v3.1/all?fields=name,flags,capital,languages,population,cca3") else { return }
        
        NetworkingManager.download(url: url) // returns the publisher we can use combine modifiers on
            .decode(type: [CountryModel].self, decoder: JSONDecoder())
            .sink(receiveCompletion: NetworkingManager.handleSinkCompletion , receiveValue: { [weak self] receivedData in
                self?.allCountries = receivedData

            })
            .store(in: &cancellables)
        
    }
    
    
    
}



// jsut to test output before decoding so i can tprint out JSON - not using actively - intialize in app when needed

class CountryDataService2 {
    

    var cancellables: Set<AnyCancellable> = []
    
    
    init() {
        
        getData()
    }
    
    
    func getData() {
        
        guard let url = URL(string: "https://restcountries.com/v3.1/all?fields=name,flags,capital,languages,population,cca3") else { return }
        
        URLSession.shared.dataTaskPublisher(for: url)
            .subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: DispatchQueue.main)
            .tryMap { (data, response) -> Data in
                
                guard
                    let response = response as? HTTPURLResponse,
                        response.statusCode >= 200 && response.statusCode < 300
                else {
                    throw URLError(.badServerResponse)
                }
                
                print(data)
                return data
            }
            .sink { recievedCompletion in
                print("good")
            } receiveValue: { receivedData in
                print(receivedData)
                let jsonString = String(data: receivedData, encoding: .utf8)
                print(jsonString)
            }
            .store(in: &cancellables)
        
    }
    
    
    
}
