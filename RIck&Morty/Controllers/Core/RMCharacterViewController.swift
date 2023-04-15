//
//  RMCharacterViewController.swift
//  RIck&Morty
//
//  Created by Jahongir Anvarov on 11.04.2023.
//

import UIKit

/// Controller to show and search Characters
final class RMCharacterViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        title = "Characters"
        
        let request = RMRequest(
            endpoint: .character,
           // pathComponent: ["1"]
        queryParameters: [
            URLQueryItem(name: "name", value: "rick"),
            URLQueryItem(name: "status", value: "alive")
            ]
        )
        print(request.url)
        
//        RMService.shared.execute(request,
//                                 expecting: RMCharacter.self/*String.self*/) { result in
//            switch result {
//            case .success(<#T##Success#>)
//
//            }
//        }
    }
    
}
