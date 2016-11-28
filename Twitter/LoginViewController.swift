//
//  LoginViewController.swift
//  Twitter
//
//  Created by Daniel Liu on 11/17/16.
//  Copyright © 2016 Daniel Liu. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class LoginViewController: UIViewController, HamburgerViewControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onLoginButton(_ sender: Any) {
        
        TwitterClient.sharedInstance.login(success: { () -> () in
            self.performSegue(withIdentifier: "loginSegue", sender: nil)
        }, failure: { (error: Error) -> () in
            print("error: \(error.localizedDescription)")
        })

        
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        let navigationController = segue.destination as! UINavigationController
        // Pass the selected object to the new view controller.
        
        
//        let tweetsViewController = navigationController.topViewController as! TweetsViewController
//        
//        tweetsViewController.delegate = self
        
        let hamburgerViewController = navigationController.topViewController as! HamburgerViewController
        hamburgerViewController.delegate = self

    }
 

}
