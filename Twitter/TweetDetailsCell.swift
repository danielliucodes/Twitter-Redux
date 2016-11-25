//
//  TweetDetailsCell.swift
//  Twitter
//
//  Created by Daniel Liu on 11/24/16.
//  Copyright © 2016 Daniel Liu. All rights reserved.
//

import UIKit

class TweetDetailsCell: UITableViewCell {
    
    @IBOutlet weak var thumbnailView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var handleLabel: UILabel!
    @IBOutlet weak var postLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    var tweet: Tweet! {
        didSet{
            thumbnailView.setImageWith((tweet.user?.profile_url)!)
            nameLabel.text = tweet.user?.name
            handleLabel.text = "@" + (tweet.user?.screenname)!
            timeLabel.text = DateFormatter.localizedString(from: tweet.timestamp!, dateStyle: DateFormatter.Style.medium, timeStyle: DateFormatter.Style.short)
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
    
}
