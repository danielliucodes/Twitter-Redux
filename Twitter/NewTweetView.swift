//
//  NewTweetView.swift
//  Twitter
//
//  Created by Daniel Liu on 11/24/16.
//  Copyright © 2016 Daniel Liu. All rights reserved.
//

import UIKit

class NewTweetView: UIView {
    
    @IBOutlet weak var thumbnailView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var handleLabel: UILabel!
    @IBOutlet weak var postView: UITextView!
    
    var user: User! {
        didSet{
            thumbnailView.setImageWith(user.profile_url!)
            nameLabel.text = user.name
            handleLabel.text = user.screenname
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        postView.becomeFirstResponder()
    }
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
}
