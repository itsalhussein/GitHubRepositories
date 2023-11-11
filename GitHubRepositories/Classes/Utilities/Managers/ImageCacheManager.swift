//
//  CachingManager.swift
//  GitHubRepositories
//
//  Created by Hussein Anwar on 11/11/2023.
//

import UIKit
class ImageCache {
    static let shared = ImageCache()
    
    private let cache = NSCache<NSString, UIImage>()
    
    private init() {}
    
    func loadImage(with urlString: String, completion: @escaping (UIImage?) -> Void) {
        // Check if the image is already in the cache
        if let cachedImage = cache.object(forKey: urlString as NSString) {
            completion(cachedImage)
            return
        }
        
        // If not in the cache, load the image from the network
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let data = data, error == nil else {
                print("Error loading image: \(error?.localizedDescription ?? "")")
                completion(nil)
                return
            }
            
            if let image = UIImage(data: data) {
                // Store the image in the cache
                self?.cache.setObject(image, forKey: urlString as NSString)
                
                // Return the image on the main thread
                DispatchQueue.main.async {
                    completion(image)
                }
            } else {
                print("Invalid image data")
                completion(nil)
            }
        }.resume()
    }
}
