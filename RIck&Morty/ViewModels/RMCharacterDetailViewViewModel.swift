//
//  RMCharacterDetailViewViewModel.swift
//  RIck&Morty
//
//  Created by Jahongir Anvarov on 10.05.2023.
//

import Foundation

final class RMCharacterDetailViewViewModel {
    let character: RMCharacter
    
    init(character: RMCharacter) {
        self.character = character
    }
    
    public var title: String {
        character.name.uppercased()
    }
}
