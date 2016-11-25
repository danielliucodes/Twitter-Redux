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

class TweetsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, TweetsViewControllerDelegate, TweetDetailsViewControllerDelegate, NewTweetViewControllerDelegate {
    
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
        
        TwitterClient.sharedInstance.homeTimeline(success: { (tweets: [Tweet]) -> () in
            self.tweets = tweets
            self.tableView.reloadData()
            
        }, failure: { (error: Error) -> () in
            print(error.localizedDescription)
        })
        
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
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        // example to return the estimated height
        return 400
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
        default:
            break
            
        }
    }
    

}
