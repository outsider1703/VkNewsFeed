//
//  ViewController.swift
//  VkNewsFeed
//
//  Created by Macbook on 08.01.2021.
//

import UIKit
import VK_ios_sdk

class AuthViewController: UIViewController {

    private var authService: AuthService!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        authService = SceneDelegate.shared().authService
    }

    @IBAction func signInTouch(_ sender: UIButton) {
        authService.wakeUpSession()
    }
    
}

