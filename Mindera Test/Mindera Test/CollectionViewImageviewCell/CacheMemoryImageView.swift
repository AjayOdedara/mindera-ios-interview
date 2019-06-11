//
//  CacheMemoryImageView.swift
//  Mindera Test
//
//  Created by Ajay Odedra on 11/06/19.
//  Copyright © 2019 Ajay Odedra. All rights reserved.
//

import Foundation
import UIKit

class CacheMemoryImageView: UIImageView {
    
    private var urlKey: String! = nil
    
    func loadImage(atURL url: URL, placeHolder: Bool = true, completion: (()-> Void)? = nil){
        
        self.urlKey = url.absoluteString
        if let cachedImage = CachedMemoryManager.shared.retrieveCachedImage(for: urlKey){
            completion?()
            self.image = cachedImage
            return
        }else{
            if placeHolder{
                self.image = UIImage(named: "placeHolder")
            }
            
            PhotoNetworkManager.shared.download(fromURL: url) {[weak self, url] (data, error) in
                guard error == nil, let data = data else{
                    completion?()
                    return
                }
                
                if let image = UIImage(data: data){
                    //Cache image for future use
                    CachedMemoryManager.shared.cacheImage(image, forKey: url.absoluteString)
                    DispatchQueue.main.async {
                        completion?()
                        if url.absoluteString == self?.urlKey{
                            self?.image = image
                        }
                    }
                }else{
                    completion?()
                }
            }
        }
    }
    
    
}
