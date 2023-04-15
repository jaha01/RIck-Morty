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
    
    /// Privatized constructor
    private init() {}
    
    
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
         
            
        }
}
