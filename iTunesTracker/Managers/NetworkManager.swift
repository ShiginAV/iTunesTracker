//
//  NetworkManager.swift
//  iTunesTracker
//
//  Created by Alexander on 02/10/2019.
//  Copyright © 2019 Alexander Shigin. All rights reserved.
//

import UIKit

class NetworkManager {
    static let shared = NetworkManager()
    
    private init() {}
    
    func fetchSearchResult(searchText: String, completion: @escaping (TrackList?) -> Void) {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "itunes.apple.com"
        urlComponents.path = "/search"
        urlComponents.queryItems = [URLQueryItem(name: "term", value: searchText)]
        
        guard let url = urlComponents.url else {
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data else {
                completion(nil)
                return
            }
            
            let trackList = try? JSONDecoder().decode(TrackList.self, from: data)
            completion(trackList)
        }.resume()
    }
    
    func fetchImage(url: URL, completion: @escaping (UIImage?) -> Void) {
        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data else {
                completion(nil)
                return
            }
            
            let image = UIImage(data: data)
            completion(image)
        }.resume()
    }
}
