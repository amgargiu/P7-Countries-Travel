//
//  NetworkingManager.swift
//  P7-Countries-Travel
//
//  Created by Antonio Gargiulo on 2/27/26.
//

import Foundation
import Combine


class NetworkingManager {
    
    // Custom Error handler
    
    enum NetworkError : LocalizedError {
        case badURLResponse(url: URL) // whenever it's this case ti requires a URL to ba passed in
        case unkown
        
        // computed property for enum - makes something for any case
        var errorMessage: String {
            switch self {
            case .badURLResponse(url: let url):
                return "⚠️ Bad URL Response for \(url)"
            case .unkown:
                return "Unknown Error"
            }
        }
        
    }
    
    
    static func download(url: URL) -> AnyPublisher<Data, any Error> {
        
        URLSession.shared.dataTaskPublisher(for: url)
            .subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: DispatchQueue.main)
            .tryMap( {try handleURLResponse(output: $0, url: url)} ) // not sure why the try here... and why n a closure
            .eraseToAnyPublisher()
    } // End download func
    
    
    static func handleURLResponse(output: URLSession.DataTaskPublisher.Output, url: URL) throws -> Data {
        guard let response = output.response as? HTTPURLResponse,
              response.statusCode == 200 && response.statusCode < 300
        else {
            throw NetworkError.badURLResponse(url: url) // we are throwing a error type (localizedErrorType is the type for the enum I guess
        }
        return output.data
    }
    
    static func handleSinkCompletion(receivedCompletion: Subscribers.Completion<any Error>) {
        switch receivedCompletion {
        case .finished:
            print("Finished")
        case .failure(let error):
            print("Error: \(error)")
        }
    }
    
    
}
