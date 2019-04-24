//
//  Launch.swift
//  ARLiu
//
//  Created by Livia Vasconcelos on 23/04/19.
//  Copyright © 2019 LiuVasconcelos. All rights reserved.
//

import UIKit

class LaunchViewController: UIViewController {
    
    @IBOutlet weak var goToGame: UIButton!
    @IBAction func goToGame(_ sender: Any) {
        let viewController  = MainViewController.fromNib().or(MainViewController())
        self.navigationController?.isNavigationBarHidden = true
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}
