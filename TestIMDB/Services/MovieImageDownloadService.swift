//
//  MovieImageDownloadService.swift
//  TestIMDB
//
//  Created by Vladimir Milichenko on 11/19/22.
//

import UIKit

final class MovieImageDownloadService {
    
    //MARK: - Static methods
    
    static func loadImage(from url: URL, completion: @escaping (UIImage?) -> ()) -> URLSessionTask? {
        let request = URLRequest(url: url)
        var dataTask: URLSessionTask?
        
        if let data = URLCache.shared.cachedResponse(for: request)?.data,
           let image = UIImage(data: data) {
            completion(image)
        } else {
            dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
                if let data = data,
                   let httpResponse = response as? HTTPURLResponse, 200...299 ~= httpResponse.statusCode,
                   let image = UIImage(data: data) {
                    let cachedData = CachedURLResponse(response: httpResponse, data: data)
                    URLCache.shared.storeCachedResponse(cachedData, for: request)
                    
                    completion(image)
                } else {
                    completion(nil)
                }
            }
            
            dataTask?.resume()
        }
        
        return dataTask
    }
}
