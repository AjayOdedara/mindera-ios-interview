//
//  ImageCollectionViewCell.swift
//  Mindera Test
//
//  Created by Ajay Odedra on 12/06/19.
//  Copyright © 2019 Ajay Odedra. All rights reserved.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell{
    @IBOutlet weak var imageView: CacheMemoryImageView!
    var photo: Photo? = nil
    
    func initWith(_ data: Photo?){
        photo = data
        guard let photo = photo, let thumbnailURL = photo.thumbnailURL else {
            return
        }
        print(thumbnailURL)
        self.imageView.loadImage(atURL: thumbnailURL)
    }
    
    override func prepareForReuse() {
        self.imageView.image = nil
    }
    
    func reducePriorityOfDownloadtaskForCell(){
        guard let photo = photo, let thumbnailURL = photo.thumbnailURL else {
            return
        }
        PhotoNetworkManager.shared.reducePriorityOfTask(withURL: thumbnailURL)
    }
}
