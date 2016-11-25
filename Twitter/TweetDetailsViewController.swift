//
//  TweetDetailsViewController.swift
//  Twitter
//
//  Created by Daniel Liu on 11/24/16.
//  Copyright © 2016 Daniel Liu. All rights reserved.
//

import UIKit

enum CellType: Int {
    case details = 0, actions = 1
}

@objc protocol TweetDetailsViewControllerDelegate {
    @objc optional func tweetDetailsViewController(tweetDetailsViewController: TweetDetailsViewController, tweet: Tweet)
}

class TweetDetailsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, TweetDetailsViewControllerDelegate, TweetsViewControllerDelegate {
    
    weak var delegate: TweetDetailsViewControllerDelegate?
    
    @IBOutlet weak var tableView: UITableView!
    
    var tweet: Tweet!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch CellType(rawValue: indexPath.row)! {
        case CellType.details:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TweetDetailsCell", for: indexPath) as! TweetDetailsCell
            cell.tweet = tweet
            return cell
            
        case CellType.actions:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ActionCell", for: indexPath) as! ActionCell
            cell.tweet = tweet
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Deselect row appearance after it has been selected
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tweetsViewController(tweetsViewController: TweetsViewController, tweet: Tweet) {
        self.tweet = tweet
    }
    
    @IBAction func onRetweetTap(_ sender: Any) {
        if !tweet.retweeted {
            TwitterClient.sharedInstance.retweetTweet(id: tweet.id, success: { () -> () in
                self.tweet.retweeted = true
            }, failure: { (error: Error) -> () in
                print("error: \(error.localizedDescription)")
            })
        } else {
            TwitterClient.sharedInstance.unretweetTweet(id: tweet.id, success: { () -> () in
                self.tweet.retweeted = false
            }, failure: { (error: Error) -> () in
                print("error: \(error.localizedDescription)")
            })
        }
        self.delegate?.tweetDetailsViewController!(tweetDetailsViewController: self, tweet: tweet)
    }
    
    @IBAction func onLikeTap(_ sender: Any) {
        if !tweet.liked {
            TwitterClient.sharedInstance.likeTweet(id: tweet.id, success: { () -> () in
                self.tweet.liked = true
            }, failure: { (error: Error) -> () in
                print("error: \(error.localizedDescription)")
            })
        } else {
            TwitterClient.sharedInstance.unlikeTweet(id: tweet.id, success: { () -> () in
                self.tweet.liked = false
            }, failure: { (error: Error) -> () in
                print("error: \(error.localizedDescription)")
            })
        }
        self.delegate?.tweetDetailsViewController!(tweetDetailsViewController: self, tweet: tweet)
    }
    
    @IBAction func onTimelineTap(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "replyTweetSegue" {
            let navigationController = segue.destination as! UINavigationController
            let viewController = navigationController.topViewController as! NewTweetViewController
            viewController.replyTweet = tweet
            viewController.user = User.currentUser
        }

    }
 

}
