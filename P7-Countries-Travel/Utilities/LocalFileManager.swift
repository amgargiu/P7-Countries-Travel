//
//  LocalFileManager.swift
//  P7-Countries-Travel
//
//  Created by Antonio Gargiulo on 3/5/26.
//

import Foundation
import SwiftUI



class LocalFileManager {
    
    static let instance = LocalFileManager() // signleton for shared state
    private init() {}
        

    
    //save / add
    
    func save(image: UIImage, imageName: String, folderName: String) {
        
        // create folder
        createFolderIfNeeded(folderName: folderName)
        
        // get path and data for image
        guard let imageData = image.pngData() else { return }
        guard let path = imagePath(imageName: imageName, folderName: folderName) else { return }
        
        // save image to path
        do {
            try imageData.write(to: path)
        } catch let error {
            print("error: \(error)")
        }
        
    }
    

    //get - returns UIImage
    func get(imageName: String, folderName: String) -> UIImage? {
        
        guard let path = imagePath(imageName: imageName, folderName: folderName) else { return nil }
        guard FileManager.default.fileExists(atPath: path.path) else { return nil }
        print("FM: getting image")
        return UIImage(contentsOfFile: path.path)
    }
    
    
    
    
    //Create the folder if needed
    private func createFolderIfNeeded(folderName: String) {
        
        guard let url = folderPath(folderName: folderName) else { return }
        
        if !FileManager.default.fileExists(atPath: url.path) {
            do {
                try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true)

            } catch let error {
                print("error creating folder \(error)")
            }
        }
        
    }
    
    
    //manually make folder path - URL
    private func folderPath(folderName: String) -> URL? {
        guard let path = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else { return nil }
        return path.appendingPathComponent(folderName)
    }
    
    
    //manually make image path - URL
    private func imagePath(imageName: String, folderName: String) -> URL? {
        guard let folderPath = folderPath(folderName: folderName) else { return nil }
        let imagePath = folderPath.appendingPathComponent(imageName + ".png")
        return imagePath
    }
    
    
    // Delete from FM
    
    func delete(imageName: String, folderName: String) {
        
        guard let path = imagePath(imageName: imageName, folderName: folderName) else { return }
        guard FileManager.default.fileExists(atPath: path.path) else {
            print("nothing to delete")
            return
        }
        
        do {
            try FileManager.default.removeItem(at: path)
            print("deleted file succesfully")
        } catch let error {
            print("error deleting file \(error)")
        }
    }
    
    func deleteFolder(folderName: String) {
        guard let folderURL = folderPath(folderName: folderName) else { return }
        
        do {
            try FileManager.default.removeItem(at: folderURL)
            print("deleted file succesfully")
        } catch let error {
            print("error deleting file \(error)")
        }
    }
    
    
    
    func fileCount(folderName: String) -> Int {
        
        guard let folderURL = folderPath(folderName: folderName) else { return 0 }
        
        do {
            let files = try FileManager.default.contentsOfDirectory(at: folderURL, includingPropertiesForKeys: nil)
            return files.count
        } catch {
            print("Error reading directory:", error)
            return 0
        }
    }
    
    
}
