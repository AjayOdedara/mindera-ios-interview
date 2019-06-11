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
    
    fileprivate var photosDataSource: [Photo]? = nil
    fileprivate var delegate: PhotosViewControllerProtocol? = nil
    fileprivate var itemsPerRow = MainViewControllerConstants.defaultNumberOfColumns
    fileprivate let searchController = UISearchController(searchResultsController: nil)
    fileprivate var searchString: String? = nil
    fileprivate var searckTask: DispatchWorkItem? = nil
    fileprivate var isLoading: Bool = false
    fileprivate var zooimingCellIndexPath: IndexPath? = nil
    fileprivate var isFulfillingSearchConditions: Bool{
        get{
            if let searchText = searchController.searchBar.text{
                searchString = searchText
                return true
            }else{
                return false
            }
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        
    }
    func setUp(){
        delegate = FlickrPhotoSearch()
        self.title = MainViewControllerConstants.navTitle
        self.navigationController?.navigationBar.prefersLargeTitles = true
        searchController.searchBar.delegate = self
        self.definesPresentationContext = true
        self.navigationItem.searchController = searchController
        self.navigationItem.hidesSearchBarWhenScrolling = false
        self.navigationItem.titleView = searchController.searchBar
        self.navigationItem.titleView?.tintColor = .gray
        searchController.hidesNavigationBarDuringPresentation = false
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let cell = sender as? ImageCollectionViewCell,
            let indexPath = self.collectionView?.indexPath(for: cell) {
            zooimingCellIndexPath = indexPath
            
            guard let detailViewController = segue.destination as? PhotoDetailViewController else{ return }
            detailViewController.photo = photosDataSource![indexPath.item]
        }
    }
    
    fileprivate func search(forPage pageNumber: Int, completion:@escaping ([Photo]?)->Void){
        guard let searchString = searchString else{return}
        delegate?.searchPhotos(forSearchString: searchString, pageNumber: pageNumber, andItemsPerPage: MainViewControllerConstants.itemsPerPage, completion: {[weak self](results, error) in
            self?.isLoading = false
            DispatchQueue.main.async {
                if error != nil || results?.count == 0{
                    self?.showError(error: error ?? "No Results Found")
                }else{
                    completion(results)
                }
                self?.collectionView?.reloadData()
            }
        })
        isLoading = true
    }
    
    @objc fileprivate func searchNextPage(){
        let currentPage = (photosDataSource?.count ?? 0)/MainViewControllerConstants.itemsPerPage
        search(forPage: currentPage+1, completion:{[weak self] (results) in
            guard let results = results else {return}
            self?.photosDataSource?.append(contentsOf: results)
        })
    }
    
    fileprivate func showError(error: String) {
        let alert = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay!", style: .default, handler: { action in
            self.searchController.searchBar.placeholder = MainViewControllerConstants.Messages.searchDefaultPlaceholder
            self.searchString = nil
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    
}

// MARK: - UICollectionViewDataSource implementation
extension PhotosViewController{
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return photosDataSource?.count ?? 0
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MainViewControllerConstants.cellIdentifier, for: indexPath)
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        let photo = photosDataSource![indexPath.item]
        (cell as! ImageCollectionViewCell).initWith(photo)
        
        guard let currentDataSourceSize = photosDataSource?.count else{return}
        if currentDataSourceSize - indexPath.row == (2 * itemsPerRow){
            searchNextPage()
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        (cell as! ImageCollectionViewCell).reducePriorityOfDownloadtaskForCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.size.width, height: 55)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize.zero
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: MainViewControllerConstants.footerIdentifier, for: indexPath) as! CustomFooterView
        isLoading ? footerView.loader.startAnimating(): footerView.loader.stopAnimating()
        return footerView
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension PhotosViewController: UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        
        let rowPadding = MainViewControllerConstants.cellPadding * CGFloat(itemsPerRow - 1)
        let availableSpace = self.view.frame.width - rowPadding
        let itemDimension = availableSpace/CGFloat(itemsPerRow)
        
        return CGSize(width: itemDimension, height: itemDimension)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return MainViewControllerConstants.cellPadding
    }
}


extension PhotosViewController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if isFulfillingSearchConditions{
            search(forPage: 0, completion: {[weak self] results in
                guard let results = results else{return}
                self?.photosDataSource = results
            })
            self.photosDataSource?.removeAll()
            self.collectionView?.reloadData()
            
            searchController.isActive = false
            searchBar.placeholder = searchString
        }
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar){
        searchBar.placeholder = MainViewControllerConstants.Messages.searchDefaultPlaceholder
    }
}

