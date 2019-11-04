//
//  ImageFetcher.swift
//  RSSReaderArcher
//
//  Created by Artem Karpovych on 11/4/19.
//  Copyright © 2019 Artem Karpovych. All rights reserved.
//

import Foundation
import UIKit

class ImageFetcher {
    
    static func store(image: UIImage,
                       forKey key: String) {
        if let pngRepresentation = image.pngData() {
            UserDefaults.standard.set(pngRepresentation, forKey: key)
        }
    }
    
    static func retrieveImage(forKey key: String) -> UIImage? {
        
        if let imageData = UserDefaults.standard.object(forKey: key) as? Data,
            let image = UIImage(data: imageData) {
            return image
        }
        
        return nil
    }
    
    static func savePhotos(news: [NewsPosts], completionBlock: ((Bool) -> Void)?) {
        let downloadGroup = DispatchGroup()
        
        for newsObj in news {
            guard let imageKey = newsObj.imageKey else { return }
            guard let url = URL(string: imageKey) else { return }
            
            downloadGroup.enter()
            
            self.downloadImage(from: url) { image in
                self.store(image: image, forKey: imageKey)
                downloadGroup.leave()
            }            
        }
        
        downloadGroup.notify(queue: DispatchQueue.main) {
            completionBlock?(true)
        }
    }
    
    
    static func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    static func downloadImage(from url: URL, completionBlock: ((UIImage) -> Void)?) {
        self.getData(from: url) {
            data, response, error in
            guard let data = data, error == nil else {
                return
            }
            guard let image = UIImage(data: data) else { return }
            completionBlock?(image)
        }
    }
}
