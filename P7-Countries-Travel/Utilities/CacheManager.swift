//
//  CacheManager.swift
//  P7-Countries-Travel
//
//  Created by Antonio Gargiulo on 2/22/26.
//

import Foundation
import SwiftUI


class CacheManager {
    
    static let instance = CacheManager()
    private init() {}
    
    var imageCache: NSCache<NSString, UIImage> = {
        let cache = NSCache<NSString, UIImage>()
        cache.countLimit = 250
        cache.totalCostLimit = 100 * 1024 * 1024
        return cache
    }()
    
    
    // add to cache
    func add(key: String, image: UIImage) {
        imageCache.setObject(image, forKey: key as NSString)
    }
    
    // get from cache
    func get(key: String) -> UIImage? {
        imageCache.object(forKey: key as NSString)
    }
    
    // delete from cache
    func remove(key: String) {
        imageCache.removeObject(forKey: key as NSString)
    }
    
    
}
