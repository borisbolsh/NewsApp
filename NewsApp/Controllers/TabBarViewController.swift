//
//  TabBarViewController.swift
//  NewsApp
//
//  Created by Boris Bolshakov on 10.12.21.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {

        super.viewDidLoad()

        let vc1 = HomeViewController()
        let vc2 = SettingsViewController()

        vc1.title = "Home"
        vc2.title = "Settings"

        vc1.navigationItem.largeTitleDisplayMode = .always
        vc2.navigationItem.largeTitleDisplayMode = .always

        let nav1 = UINavigationController(rootViewController: vc1)
        let nav2 = UINavigationController(rootViewController: vc2)

        nav1.navigationBar.tintColor = .label
        nav2.navigationBar.tintColor = .label
 
        nav1.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), tag: 0)
        nav2.tabBarItem = UITabBarItem(title: "Settings", image: UIImage(systemName: "gear"), tag: 1)

        nav1.navigationBar.prefersLargeTitles = true
        nav2.navigationBar.prefersLargeTitles = true

        setViewControllers([nav1, nav2], animated: false)
    }
    

    
}
