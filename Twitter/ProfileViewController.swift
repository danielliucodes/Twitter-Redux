//
//  ProfileViewController.swift
//  Twitter
//
//  Created by Daniel Liu on 11/26/16.
//  Copyright © 2016 Daniel Liu. All rights reserved.
//

import UIKit

@objc protocol ProfileViewControllerDelegate {
    @objc optional func profileViewControllerDelegate(profileViewController: ProfileViewController)
}

class ProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, TweetDetailsViewControllerDelegate, ProfileViewControllerDelegate {

    weak var delegate: ProfileViewControllerDelegate?
    
    @IBOutlet weak var profileView: ProfileView!
    @IBOutlet weak var tableView: UITableView!
    
    var tweets: [Tweet]!
    var user: User? = User.currentUser
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 400

        profileView.user = user
        
        let tweetCellXib = UINib(nibName: "TweetCellNib", bundle: nil)
        tableView.register(tweetCellXib, forCellReuseIdentifier: "TweetCellNib")
        
        TwitterClient.sharedInstance.user(screenname: (user?.screenname)!, success: { (user: User) -> () in
            self.profileView.setHeaderViewWith(url: user.header_url!)
        }, failure: { (error: Error) -> () in
            print("error: \(error.localizedDescription)")
        })
        
        TwitterClient.sharedInstance.userTimeline(screenname: (user?.screenname)!, success: { (tweets: [Tweet]) -> () in
            self.tweets = tweets
            self.tableView.reloadData()
        }, failure: { (error: Error) -> () in
            print("error: \(error.localizedDescription)")
        })
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tweets != nil {
            return tweets.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TweetCellNib", for: indexPath) as! TweetCellNib
        
        cell.tweet = tweets[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "profileDetailsSegue", sender: tableView)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
//    func tweetsViewController(tweetsViewController: TweetsViewController, tweet: Tweet) {
//        TwitterClient.sharedInstance.userTimeline(screenname: (user?.screenname)!, success: { (tweets: [Tweet]) -> () in
//            self.tweets = tweets
//            self.tableView.reloadData()
//        }, failure: { (error: Error) -> () in
//            print("error: \(error.localizedDescription)")
//        })
//    }
    
    func tweetDetailsViewController(tweetDetailsViewController: TweetDetailsViewController, tweet: Tweet) {
        TwitterClient.sharedInstance.userTimeline(screenname: (user?.screenname)!, success: { (tweets: [Tweet]) -> () in
            self.tweets = tweets
            self.tableView.reloadData()
        }, failure: { (error: Error) -> () in
            print("error: \(error.localizedDescription)")
        })
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        switch segue.identifier! {
        case "profileDetailsSegue" :
            let indexPath = tableView.indexPathForSelectedRow
            let tweet = tweets[indexPath!.row]
            
            let navigationController = segue.destination as! UINavigationController
            let viewController = navigationController.topViewController as! TweetDetailsViewController
            viewController.delegate = self
            viewController.tweet = tweet
        default:
            break
            
        }
    }
 

}
