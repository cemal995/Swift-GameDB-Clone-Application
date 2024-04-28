//
//  MainTabBarController.swift
//  gameDB
//
//  Created by Cemalhan Alptekin on 26.04.2024.
//

import UIKit

class MainTabBarController: UITabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
           if let favoritesVC = viewController as? FavoritesViewController {
               favoritesVC.reloadData()
           }
       }
}
