//
//  Track.swift
//  iTunesTracker
//
//  Created by Alexander on 02/10/2019.
//  Copyright © 2019 Alexander Shigin. All rights reserved.
//

import Foundation

struct Track: Codable {
    var artistName: String
    var collectionName: String
    var trackName: String
    var albumImage: URL
    var soundPreview: URL
    
    enum CodingKeys: String, CodingKey {
        case artistName
        case collectionName
        case trackName
        case albumImage = "artworkUrl100"
        case soundPreview = "previewUrl"
    }
}
