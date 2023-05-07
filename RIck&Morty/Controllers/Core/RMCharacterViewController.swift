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
/*
        let request = RMRequest(
            endpoint: .character,
           // pathComponent: ["1"]
        queryParameters: [
            URLQueryItem(name: "name", value: "rick"),
            URLQueryItem(name: "status", value: "alive")
            ]
        )
        print(request.url)
 */
        // MARK: -- ОШИБКА ГДЕ-ТО Здесь --
        RMService.shared.execute(.listCharactersRequests, expecting: RMGetAllCharactersResponse.self) { result in
            
            switch result {
            case .success(let model):
                print("Total: " + String(describing: model.info.count))
                print("Page result count: " + String(describing: model.result.count))
            case .failure(let error):
                print(String(describing: error))
            }
        }

    }
    
}
