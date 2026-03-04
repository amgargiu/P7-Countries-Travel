//
//  StartViewModel.swift
//  P7-Countries-Travel
//
//  Created by Antonio Gargiulo on 2/22/26.
//

import Foundation
import Combine
import SwiftUI


class StartViewModel: ObservableObject {
    
    // 1. Define the array with the data already in it
    // Using 'var' in case you want to add more later
    @Published var startImageURLs: [String] = [
        "https://wallpapers.com/images/hd/japanese-iphone-hdjn6ssqagx86nby.jpg",
        "https://papers.company/wallpaper/papers.co-na16-sky-blue-eiffel-tower-nature-paris-city-34-iphone6-plus-wallpaper.jpg",
        "https://wallpapercave.com/wp/wp12547689.jpg",
        "https://i.pinimg.com/736x/4c/69/39/4c6939bdb1e7825da73ee49d17ab5101.jpg",
        "https://i.pinimg.com/736x/72/3e/aa/723eaaf25cd18c303b71d70fd43b1659.jpg"
    ]
    @Published var downloadedImages: [UIImage?] = []
    var cancellables: Set<AnyCancellable> = []
    let cachManager = CacheManager.instance
    
    
    init() {
        // 2. Pre-fill the array with nils matching the count of URLs
        self.downloadedImages = Array(repeating: nil, count: startImageURLs.count)
        getStartImages()
    }
    
    func getStartImages() {
            // 3. Use enumerated() to get the index and the URL
            for (index, imageURL) in startImageURLs.enumerated() {
                if let cachedImage = cachManager.get(key: imageURL) {
                    self.downloadedImages[index] = cachedImage
                    print("using cached image at index \(index)")
                } else {
                    downloadStartImage(urlstring: imageURL, at: index)
                }
            }
        }
    
    private func downloadStartImage(urlstring: String, at index: Int) {
            guard let url = URL(string: urlstring) else { return }
            
            URLSession.shared.dataTaskPublisher(for: url)
                .subscribe(on: DispatchQueue.global(qos: .background))
                .receive(on: DispatchQueue.main)
                .map { UIImage(data: $0.data) }
                .sink { _ in
                    print("Finished task for index \(index)")
                } receiveValue: { [weak self] receivedImage in
                    guard let self = self, let image = receivedImage else { return }
                    
                    // 4. Place the image in its specific "reserved seat"
                    self.downloadedImages[index] = image
                    self.cachManager.add(key: urlstring, image: image)
                }
                .store(in: &cancellables)

    }
    
}
