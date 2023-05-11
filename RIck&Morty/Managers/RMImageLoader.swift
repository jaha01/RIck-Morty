//
//  ImageLoader.swift
//  RIck&Morty
//
//  Created by Jahongir Anvarov on 11.05.2023.
//

import Foundation

final class RMImageLoader {
    static let shared = RMImageLoader()
    
    private init() {}
    
    private var imageDataCache = NSCache<NSString, NSData>() //  создаем кэш для изображений
    
    /// Get image content with URL
    /// - Parameters:
    ///   - url: Source url
    ///   - completion: Callback
    func downloadImage(_ url: URL, completion: @escaping(Result<Data, Error>) -> Void) {
        let key = url.absoluteString as NSString
        if let data = imageDataCache.object(forKey: key) {
            completion(.success(data as Data)) // NSData == Data | NSString == String
            return
        }
        
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, _, error in
            guard let data = data, error == nil else {
                completion(.failure(error ?? URLError(.badServerResponse)))
                return
            }
            let key = url.absoluteString as NSString
            let value = data as NSData
            self?.imageDataCache.setObject(value, forKey: key)
            completion(.success(data))
        }
        task.resume()
    }
}
