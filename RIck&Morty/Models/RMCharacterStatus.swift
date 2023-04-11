//
//  RMCharacterStatus.swift
//  RIck&Morty
//
//  Created by Jahongir Anvarov on 11.04.2023.
//

import Foundation

enum RMCharacterStatus: String, Codable {
    //('Alive', 'Dead' or 'unknown') from website
    case alive = "Alive"
    case dead = "Dead"
    case unknown = "unknown"
}
