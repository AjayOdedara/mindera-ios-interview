//
//  Mindera_TestTests.swift
//  Mindera TestTests
//
//  Created by Ajay Odedra on 09/06/19.
//  Copyright © 2019 Ajay Odedra. All rights reserved.
//

import XCTest
@testable import Mindera_Test

class Mindera_TestTests: XCTestCase {
    fileprivate var delegate: PhotosViewControllerProtocol? = nil
    var photos = [Photo]()
    
    override func setUp() {
        delegate = FlickrPhotoSearch()
        
        let expectHandlerCall = XCTestExpectation(description: "Fkickr Search Response")
        delegate?.searchPhotos(forSearchString: "Mindera", pageNumber: 1, andItemsPerPage: 25, completion: { (results, error) in
            if error != nil || results?.count == 0{
                print("No Results Found")
                XCTFail()
            }else{
                self.photos = results!
                print(results)
                expectHandlerCall.fulfill()
            }
        })
        // Wait until the expectation is fulfilled, with a timeout of 10 seconds.
        wait(for: [expectHandlerCall], timeout: 10.0)
    }
    
    
    func testCacheMemoryAndLargeImageLoad() {
        let expectHandlerCall = XCTestExpectation(description: "Detail High resolution image download done")
        if let photo = photos.first, let highResPhotoURL = photo.highResPhotoURL{
            if CachedMemoryManager.shared.isImageCached(for: highResPhotoURL.absoluteString){
                print("Already Loaded")
                expectHandlerCall.fulfill()
            } else {
                let imgView = CacheMemoryImageView()
                imgView.loadImage(atURL: highResPhotoURL, placeHolder: false, completion: {
                    expectHandlerCall.fulfill()
                })
            }
        }else{
            XCTFail()
        }
        // Wait until the expectation is fulfilled, with a timeout of 10 seconds.
        wait(for: [expectHandlerCall], timeout: 15.0)
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
