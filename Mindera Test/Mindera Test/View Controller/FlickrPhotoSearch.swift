//
//  FlickrPhotoSearch.swift
//  Mindera Test
//
//  Created by Ajay Odedra on 11/06/19.
//  Copyright © 2019 Ajay Odedra. All rights reserved.
//

import Foundation
import UIKit

protocol Photo {
    var thumbnailURL: URL? {get}
    var highResPhotoURL: URL? {get}
}


private struct FlickrProviderConstants{
    static let apiKey = "f9cc014fa76b098f9e82f1c288379ea1"
    static let flickrAPIBaseURL = "https://api.flickr.com/services/rest/"
    static let stat = "stat"
    static let ok = "ok"
    static let photos = "photos"
    static let photo = "photo"
    static let id = "id"
    static let farm = "farm"
    static let server = "server"
    static let secret = "secret"
    struct Messages {
        static let searchURLCreationFailed = "Failed to create search URL."
        static let parsingFailed = "Failed to parse result."
    }
}

