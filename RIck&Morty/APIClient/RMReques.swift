//
//  RMReques.swift
//  RIck&Morty
//
//  Created by Jahongir Anvarov on 11.04.2023.
//

import Foundation
import UIKit

/// Object that represents a sungle API Call
final class RMRequest {
    
    // Base url
    // Endpoint
    // Path components
    // Query parameters
    
    /// API Constants
    private struct Constants {
        static let baseUrl = "https://rickandmortyapi.com/api"
    }
    /// Desired endpoint
    private let endpoint: RMEndpoint
    /// Path components foa API, if Any
    private let pathComponents: [String] //Set<String>
    /// Query arguments for API, if Any
    private let queryParameters: [URLQueryItem]
    /// Constructed url for the api request in string format
    private var urlString: String {
        var string = Constants.baseUrl
        string += "/"
        string += endpoint.rawValue
        
        if !pathComponents.isEmpty {
            pathComponents.forEach({
                string += "/\($0)"
            })
        }
        
        if !queryParameters.isEmpty {
            string += "?"
            let argumentString = queryParameters.compactMap({
                guard let value = $0.value else { return nil }
                return "\($0.name)=\(value)"
            }).joined(separator: "&")
            
            string += argumentString
        }
        //print(string)
        return string
    }
    /// Computed & constructed API url
    public var url: URL? {
        return URL(string: urlString)
    }
    /// Desire http method
    public let httpMethod = "GET"
    // MARK: - Public
    
    public init(endpoint: RMEndpoint,
                pathComponent: [String] = [], //Set<String> = [],
                queryParameters: [URLQueryItem] = []
    ) {
        self.endpoint = endpoint
        self.pathComponents = pathComponent
        self.queryParameters = queryParameters
    }
    
    convenience init?(url: URL) {
        let string = url.absoluteString
        if !string.contains(Constants.baseUrl) {
            return nil
        }
        let trimmed = string.replacingOccurrences(of: Constants.baseUrl+"/", with: "")
        if trimmed.contains("/") {
            let components = trimmed.components(separatedBy: "/")
            if !components.isEmpty {
                let endpointString = components[0]
                if let rmEndpoint = RMEndpoint(rawValue: endpointString) {
                    self.init(endpoint: rmEndpoint)
                    return
                }
            }
        } else if trimmed.contains("?") {
            let components = trimmed.components(separatedBy: "?")
            if !components.isEmpty, components.count >= 2 {
                let endpointString = components[0]
                let queryItemString = components[1]
                let queryItems: [URLQueryItem] = queryItemString.components(separatedBy: "&").compactMap({
                    guard $0.contains("=") else {
                        return nil
                    }
                    let parts = $0.components(separatedBy: "=")
                    return URLQueryItem(
                    name: parts[0],
                    value: parts[1]
                    )
                })
                if let rmEndpoint = RMEndpoint(rawValue: endpointString) {
                    self.init(endpoint: rmEndpoint, queryParameters: queryItems)
                    return
                }
            }
        }
        return nil
    }
}


extension RMRequest {
    static let listCharactersRequests = RMRequest(endpoint: .character)
}
