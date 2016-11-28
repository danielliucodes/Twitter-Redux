//
//  ProfileView.swift
//  Twitter
//
//  Created by Daniel Liu on 11/26/16.
//  Copyright © 2016 Daniel Liu. All rights reserved.
//

import UIKit

class ProfileView: UIView {

    @IBOutlet weak var headerView: UIImageView!
    @IBOutlet weak var thumbnailView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var handleLabel: UILabel!
    @IBOutlet weak var tweetsNumberLabel: UILabel!
    @IBOutlet weak var followingNumberLabel: UILabel!
    @IBOutlet weak var followersNumberLabel: UILabel!
    
    @IBOutlet weak var tweetsLabel: UILabel!
    @IBOutlet weak var followingLabel: UILabel!
    @IBOutlet weak var followersLabel: UILabel!
    
    var user: User! {
        didSet{
            thumbnailView.setImageWith(user.profile_url!)
            nameLabel.text = user.name
            handleLabel.text = "@" + (user.screenname)!
            tweetsNumberLabel.text = "\(user.tweetsCount)"
            followingNumberLabel.text = "\(user.followingCount)"
            followersNumberLabel.text = "\(user.followersCount)"
        }
    }
    
    func setHeaderViewWith(url: URL) {
        headerView.setImageWith(url)
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
