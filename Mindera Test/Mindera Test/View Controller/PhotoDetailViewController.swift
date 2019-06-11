//
//  PhotoDetailViewController.swift
//  Mindera Test
//
//  Created by Ajay Odedra on 11/06/19.
//  Copyright © 2019 Ajay Odedra. All rights reserved.
//

import UIKit

class PhotoDetailViewController: UIViewController{
    var photo: Photo? = nil
    @IBOutlet weak var imageView: CacheMemoryImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        self.navigationItem.largeTitleDisplayMode = .never
        self.activityIndicator.stopAnimating()
        
        if let _ = photo, let highResPhotoURL = photo?.highResPhotoURL{
            if CachedMemoryManager.shared.isImageCached(for: highResPhotoURL.absoluteString){
                imageView.loadImage(atURL: highResPhotoURL)
            } else if let thumbnailURL = photo?.thumbnailURL{
                imageView.loadImage(atURL: thumbnailURL)
                activityIndicator.startAnimating()
                imageView.loadImage(atURL: highResPhotoURL, placeHolder: false, completion: {[weak self] in
                    DispatchQueue.main.async {
                        self?.activityIndicator.stopAnimating()
                    }
                })
            }
        }
        
        //Adds a GestureRecognizer for downward swipes that calls swipeDown()
        let swipeDownGestureRec = UISwipeGestureRecognizer(target: self, action: #selector(swipeDown))
        swipeDownGestureRec.direction = .down
        self.view.addGestureRecognizer(swipeDownGestureRec)
        
    }
    
    //Dismisses the ViewController
    @objc func swipeDown() {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func closePresentAction(_ sender: Any) {
        swipeDown()
    }
    
}
