//
//  User.swift
//  Twitter
//
//  Created by Daniel Liu on 11/19/16.
//  Copyright © 2016 Daniel Liu. All rights reserved.
//

import UIKit

class User: NSObject {
    
    static let userDidLogoutNotification = NSNotification.Name(rawValue: "UserDidLogout")
    
    var dictionary: NSDictionary?
    
    var name: String?
    var screenname: String?
    var profile_url: URL?
    var tagline: String?
    
    init(dictionary: NSDictionary) {
        self.dictionary = dictionary
        
        name = dictionary["name"] as? String
        screenname = dictionary["screen_name"] as? String
        
        let profileUrlString = dictionary["profile_image_url_https"] as? String
        if let profileUrlString = profileUrlString {
            profile_url = URL(string: profileUrlString)
        }
        tagline = dictionary["description"] as? String
    }
    
    static var _currentUser: User?
    
    class var currentUser: User? {
        get {
            if _currentUser == nil {
                let defaults = UserDefaults.standard
                let userData = defaults.object(forKey: "currentUserData") as? Data
                if let userData = userData {
                    let userDictionary = try! JSONSerialization.jsonObject(with: userData, options: []) as! NSDictionary
                    _currentUser = User(dictionary: userDictionary)
                }
            }
            return _currentUser
        }
        set(user) {
            _currentUser = user
            let defaults = UserDefaults.standard
            if let user = user {
                let data = try! JSONSerialization.data(withJSONObject: user.dictionary!, options: [])
                defaults.set(data, forKey: "currentUserData")
            } else {
                defaults.removeObject(forKey: "currentUserData")
            }
            defaults.synchronize()
        }
    }
    
}
