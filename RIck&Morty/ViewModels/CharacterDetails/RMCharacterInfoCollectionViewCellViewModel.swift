//
//  RMCharacterInfoCollectionViewCellViewModel.swift
//  RIck&Morty
//
//  Created by Jahongir Anvarov on 14.05.2023.
//

import Foundation

final class RMCharacterInfoCollectionViewCellViewModel {
    public let value: String
    public let title: String
    
    init(value: String, title: String) {
        self.value = value
        self.title = title
    }
}
