//
//  CachedMemoryManager.swift
//  Mindera Test
//
//  Created by Ajay Odedra on 11/06/19.
//  Copyright © 2019 Ajay Odedra. All rights reserved.
//

import UIKit

class CachedMemoryManager {
    static let shared: CachedMemoryManager = CachedMemoryManager()
    private let imageCache: NSCache<NSString, UIImage>
    private init(){
        imageCache = NSCache<NSString, UIImage>()
    }
    
    func retrieveCachedImage(for key: String) -> UIImage?{
        return self.imageCache.object(forKey: key as NSString)
    }
    
    func cacheImage(_ image: UIImage, forKey key: String) {
        self.imageCache.setObject(image, forKey: key as NSString)
    }
    
    func isImageCached(for key: String) -> Bool{
        if let _ = self.retrieveCachedImage(for: key){
            return true
        }
        return false
    }
}

