//
//  TweetCell.swift
//  Twitter
//
//  Created by Daniel Liu on 11/22/16.
//  Copyright © 2016 Daniel Liu. All rights reserved.
//

import UIKit

class TweetCell: UITableViewCell {

    @IBOutlet weak var thumbnailView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var handleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var postLabel: UILabel!
    
    var tweet: Tweet! {
        didSet{
            thumbnailView.setImageWith((tweet.user?.profile_url)!)
            nameLabel.text = tweet.user?.name
            handleLabel.text = "@" + (tweet.user?.screenname)!
            timeLabel.text = TwitterClient.calculateTimeDifference(dateOfTweet: tweet.timestamp!)
            postLabel.text = tweet.text
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
//    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        
//        postLabel.preferredMaxLayoutWidth = postLabel.frame.size.width
//    }
    
    

}
