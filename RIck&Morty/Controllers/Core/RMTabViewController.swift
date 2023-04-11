//
//  ViewController.swift
//  RIck&Morty
//
//  Created by Jahongir Anvarov on 11.04.2023.
//

import UIKit

/// Controllers to house tabs and root tab controllers
final class RMTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor  = .red
        setupUpTabs()
    }

    private func setupUpTabs() {
        let characterVC = RMCharacterViewController()
        let locationsVC = RMlocationViewController()
        let episodsVC    = RMEpisodeViewController()
        let settingsVC  = RMSettingsViewController()
        
//        characterVC.title = "Characters"
//        locationsVC.title = "Locations"
//        episodsVC.title   = "Episods"
//        settingsVC.title  = "Setiings"
// move to each ViewControllers e.g. title = "Characters"
        
        characterVC.navigationItem.largeTitleDisplayMode = .automatic // auto because we set it in (*)
        locationsVC.navigationItem.largeTitleDisplayMode = .automatic
        episodsVC.navigationItem.largeTitleDisplayMode = .automatic
        settingsVC.navigationItem.largeTitleDisplayMode = .automatic
        
        
        let nav1 = UINavigationController(rootViewController: characterVC)
        let nav2 = UINavigationController(rootViewController: locationsVC)
        let nav3 = UINavigationController(rootViewController: episodsVC)
        let nav4 = UINavigationController(rootViewController: settingsVC)
        
        nav1.tabBarItem = UITabBarItem(title: "Characters", image: UIImage(systemName: "person"), tag: 1)
        nav2.tabBarItem = UITabBarItem(title: "Locations", image: UIImage(systemName: "globe"), tag: 2)
        nav3.tabBarItem = UITabBarItem(title: "Episods", image: UIImage(systemName: "tv"), tag: 3)
        nav4.tabBarItem = UITabBarItem(title: "Setiings", image: UIImage(systemName: "gear"), tag: 4)
        
        
        for nav in [nav1, nav2, nav3, nav4] {
            nav.navigationBar.prefersLargeTitles = true // make large title (*)
        }
        
        setViewControllers([nav1, nav2, nav3, nav4], animated: true)
        
    }

}

