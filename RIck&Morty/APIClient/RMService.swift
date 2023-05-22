//
//  RMService.swift
//  RIck&Morty
//
//  Created by Jahongir Anvarov on 11.04.2023.
//

import Foundation

/// Primary API service object to get Rick and Morty data
final class RMService {
    /// Shared singleton instance
    static let shared = RMService()
    
    let cacheManager = RMAPICacheManager()
    /// Privatized constructor
    private init() {}
    
    enum RMServiceError: Error {
        case failedToCreateRequest
        case failedToGetData
    }
    
    /// Send Rick and Morty API Call
    /// - Parameters:
    ///   - request: Request instance
    ///   - completion: Callback with data or error
//    public func execute(_ request: RMRequest, completion: @escaping () -> Void) {
//
//    }  переделаем функцию с дженериками ПОЧИТАЙ!!!
//    type the type of object we expect to get back
    public func execute<T: Codable> (
        _ request: RMRequest,
        expecting type: T.Type,
        completion: @escaping (Result<T, Error>) -> Void
        ) {
            if let cachedData = cacheManager.cachedResponse(for: request.endpoint, url: request.url) {
                print("Using cahed API Response")
                do {
                    let result = try JSONDecoder().decode(type.self, from: cachedData)
                    
                    completion(.success(result))
                    return
                }
                catch {
                    completion(.failure(error))
                }
                return
            }
           guard let urlRequest = self.request(from: request) else {
                completion(.failure(RMServiceError.failedToCreateRequest))
                return
            }
            let task = URLSession.shared.dataTask(with: urlRequest) { [ weak self ] data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(error ?? RMServiceError.failedToGetData))
                    return
                }
//                Decode response
                do {
//                    let json = try JSONSerialization.jsonObject(with: data)
//                    print(String(describing: json))
                    self?.cacheManager.setCahe(for: request.endpoint, url: request.url, data: data)
                    let result = try JSONDecoder().decode(type.self, from: data)
//                    print(String(describing: result))
                    completion(.success(result))
                }
                catch {
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    
    // MARK: - Private
    
    private func request(from rmRequest: RMRequest) -> URLRequest? {
        guard let url = rmRequest.url else { return nil }
        
        var request = URLRequest(url: url)
        request.httpMethod = rmRequest.httpMethod
        return request
    }
}
