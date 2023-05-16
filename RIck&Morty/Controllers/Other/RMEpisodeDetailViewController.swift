//
//  RMEpisodeDetailViewController.swift
//  RIck&Morty
//
//  Created by Jahongir Anvarov on 16.05.2023.
//

import UIKit

/// VC to show details about single episode
final class RMEpisodeDetailViewController: UIViewController {

    private let url: URL?
    
    //MARK: - Init
    init(url: URL?) {
        self.url = url
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    // Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGreen
        // Do any additional setup after loading the view.
    }

}
