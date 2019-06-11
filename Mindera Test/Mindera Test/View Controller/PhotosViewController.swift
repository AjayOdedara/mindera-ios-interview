//
//  ViewController.swift
//  Mindera Test
//
//  Created by Ajay Odedra on 09/06/19.
//  Copyright © 2019 Ajay Odedra. All rights reserved.
//

import UIKit

private struct MainViewControllerConstants{
    static let cellPadding: CGFloat = 10.0
    static let defaultNumberOfColumns = 2
    static let cellIdentifier = "ImageCollectionViewCell"
    static let footerIdentifier = "CustomFooterView"
    static let itemsPerPage = 15
    static let navTitle = "Flickr Search"
    
    struct Messages{
        static let searchDefaultPlaceholder = "Search"
    }
}
protocol PhotosViewControllerProtocol {
    func searchPhotos(forSearchString searchString: String, pageNumber: Int, andItemsPerPage itemsPerPage: Int, completion: @escaping ([Photo]?, String?)-> Void)
}

class PhotosViewController: UICollectionViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }


}

