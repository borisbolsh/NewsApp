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

        let viewController1 = HomeViewController()
        let viewController2 = TopNewsViewController()
        let viewController3 = SettingsViewController()
        
//        viewController1.title = ""
        viewController2.title = "Top News"
        viewController3.title = "Settings"
        
        viewController1.navigationItem.largeTitleDisplayMode = .never
        viewController2.navigationItem.largeTitleDisplayMode = .always
        viewController3.navigationItem.largeTitleDisplayMode = .always
      
        let navigationController1 = UINavigationController(rootViewController: viewController1)
        let navigationController2 = UINavigationController(rootViewController: viewController2)
        let navigationController3 = UINavigationController(rootViewController: viewController3)
        
        navigationController1.navigationBar.tintColor = .label
        navigationController2.navigationBar.tintColor = .label
        navigationController3.navigationBar.tintColor = .label
        
        navigationController1.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), tag: 0)
        navigationController2.tabBarItem = UITabBarItem(title: "Top News", image: UIImage(systemName: "star"), tag: 1)
        navigationController3.tabBarItem = UITabBarItem(title: "Settings", image: UIImage(systemName: "gear"), tag: 2)
        
        navigationController1.navigationBar.prefersLargeTitles = true
        navigationController2.navigationBar.prefersLargeTitles = true
        navigationController3.navigationBar.prefersLargeTitles = true
        
        setViewControllers([
            navigationController1,
            navigationController2,
            navigationController3
        ], animated: false)
        
    }
    

    
}
