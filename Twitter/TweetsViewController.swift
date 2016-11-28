//
//  TweetsViewController.swift
//  Twitter
//
//  Created by Daniel Liu on 11/19/16.
//  Copyright © 2016 Daniel Liu. All rights reserved.
//

import UIKit

@objc protocol TweetsViewControllerDelegate {
    @objc optional func tweetsViewController(tweetsViewController: TweetsViewController, tweet: Tweet)
}

class TweetsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate, TweetsViewControllerDelegate, TweetDetailsViewControllerDelegate, NewTweetViewControllerDelegate, ProfileViewControllerDelegate {
    
    weak var delegate: TweetsViewControllerDelegate?
    
    @IBOutlet weak var tableView: UITableView!

    var tweets: [Tweet]! = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 400
        tableView.rowHeight = UITableViewAutomaticDimension
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(refreshControl:)), for: UIControlEvents.valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
        
        TwitterClient.sharedInstance.homeTimeline(
            success: { (tweets: [Tweet]) -> () in
                self.tweets = tweets
                self.tableView.reloadData()
                
        }, failure: { (error: Error) -> () in
            print("error: \(error.localizedDescription)")
        })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tweets != nil {
            return tweets!.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TweetCell", for: indexPath) as! TweetCell
        
        cell.tweet = tweets[indexPath.row]
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onUserTap(_:)))
//        tapGesture.delegate = self
        cell.thumbnailView.isUserInteractionEnabled = true
        cell.thumbnailView.addGestureRecognizer(tapGesture)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Deselect row appearance after it has been selected
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tweetDetailsViewController(tweetDetailsViewController: TweetDetailsViewController, tweet: Tweet) {
        TwitterClient.sharedInstance.homeTimeline(
            success: { (tweets: [Tweet]) -> () in
                self.tweets = tweets
                self.tableView.reloadData()
        
        }, failure: { (error: Error) -> () in
            print("error: \(error.localizedDescription)")
        })
    }
    
    func newTweetViewController(newTweetViewController: NewTweetViewController, tweet: Tweet) {
        self.tweets.insert(tweet, at: 0)
        self.tableView.reloadData()
    }

    func profileViewControllerDelegate(profileViewController: ProfileViewController) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onLogoutButton(_ sender: Any) {
        TwitterClient.sharedInstance.logout()
    }
    
    
    func refreshControlAction(refreshControl: UIRefreshControl) {
        TwitterClient.sharedInstance.homeTimeline(
            success: { (tweets: [Tweet]) -> () in
                self.tweets = tweets
                self.tableView.reloadData()
                refreshControl.endRefreshing()
                
        }, failure: { (error: Error) -> () in
            print("error: \(error.localizedDescription)")
        })
    }
    
    func onUserTap(_ sender: UITapGestureRecognizer) {
        print("gesture tap recognized")
        
        let location = sender.location(in: tableView)
        let indexPath = tableView.indexPathForRow(at: location)
        let tweet = tweets[(indexPath?.row)!]

        //let profileViewController = storyboard?.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
        let profileNavigationController = storyboard?.instantiateViewController(withIdentifier: "profileNavigationController") as! UINavigationController
        let profileViewController = profileNavigationController.topViewController as! ProfileViewController

        profileViewController.user = tweet.user
        
        print("user for tweet is \(tweet.user?.name)")
        
        self.navigationController?.pushViewController(profileViewController, animated: true)
        
//        self.performSegue(withIdentifier: "tweetProfileSegue", sender: sender)
        
        
        
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        switch segue.identifier! {
        case "tweetDetailsSegue" :
            let cell = sender as! TweetCell
            let indexPath = tableView.indexPath(for: cell)
            let tweet = tweets[indexPath!.row]
            
            let navigationController = segue.destination as! UINavigationController
            let viewController = navigationController.topViewController as! TweetDetailsViewController
            viewController.delegate = self
            viewController.tweet = tweet
            
            self.delegate = viewController
        case "newTweetSegue" :
            let navigationController = segue.destination as! UINavigationController
            let viewController = navigationController.topViewController as! NewTweetViewController
            viewController.delegate = self
            viewController.user = User.currentUser
            
        case "tweetProfileSegue" :
            //let sender = sender as! UITapGestureRecognizer
            //let location = sender.location(in: tableView)
            //let indexPath = tableView.indexPathForRow(at: location)
            //let tweet = tweets[(indexPath?.row)!]
            let cell = sender as! TweetCell
            let indexPath = tableView.indexPath(for: cell)
            let tweet = tweets[indexPath!.row]
            
//            let profileViewController = storyboard?.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
//            profileViewController.user = tweet.user
            
            
            let navigationController = segue.destination as! UINavigationController
            let viewController = navigationController.topViewController as! ProfileViewController
            
            viewController.user = tweet.user
            
            viewController.delegate = self
            
//            self.delegate = viewController
        default:
            break
            
        }
    }
    

}
