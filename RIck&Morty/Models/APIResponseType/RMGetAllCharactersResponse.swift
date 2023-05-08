//
//  RMGetAllCharactersResponse.swift
//  RIck&Morty
//
//  Created by Jahongir Anvarov on 24.04.2023.
//

import Foundation

struct RMGetAllCharactersResponse: Codable {
    struct Info: Codable {
        let count: Int
        let pages: Int
        let next: String?
        let prev: String?
    }
    
    let info: Info
    let results: [RMCharacter]
}
