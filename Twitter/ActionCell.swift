//
//  ActionCell.swift
//  Twitter
//
//  Created by Daniel Liu on 11/25/16.
//  Copyright © 2016 Daniel Liu. All rights reserved.
//

import UIKit

class ActionCell: UITableViewCell {
    
    @IBOutlet weak var retweetedLabel: UILabel!
    @IBOutlet weak var likedLabel: UILabel!
    
    @IBOutlet weak var replyButton: UIButton!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var likeButton: UIButton!
    
    var tweet: Tweet! {
        didSet {
            retweetedLabel.text = "\(tweet.retweetCount) " + (tweet.retweetCount == 1 ? "RETWEET" : "REWTEETS")
            likedLabel.text = "\(tweet.likeCount) " + (tweet.likeCount == 1 ? "LIKE" : "LIKES")
            
            retweetButton.isSelected = tweet.retweeted
            likeButton.isSelected = tweet.liked
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @IBAction func onLikeTap(_ sender: AnyObject) {
        likeButton.isSelected = !tweet.liked
        
        if !likeButton.isSelected {
            tweet.likeCount -= 1
            
        } else {
            tweet.likeCount += 1
        }
        
        likedLabel.text = "\(tweet.likeCount) " + (tweet.likeCount == 1 ? "LIKE" : "LIKES")
    }
    
    @IBAction func onRetweetTap(_ sender: AnyObject) {
        retweetButton.isSelected = !tweet.retweeted
        
        if !retweetButton.isSelected {
            tweet.retweetCount -= 1
        } else {
            tweet.retweetCount += 1
        }
        
        retweetedLabel.text = "\(tweet.retweetCount) " + (tweet.retweetCount == 1 ? "RETWEET" : "REWTEETS")
    }
    
}
