//
//  Tweet.swift
//  Twitter
//
//  Created by Daniel Liu on 11/19/16.
//  Copyright © 2016 Daniel Liu. All rights reserved.
//

import UIKit

class Tweet: NSObject {

    var text: String?
    var timestamp: Date?
    var retweetCount: Int = 0
    var likeCount: Int = 0
    var id: NSNumber = 0
    var user: User?
    
    var retweeted = false
    var liked = false
    
    init(dictionary: NSDictionary) {
        text = dictionary["text"] as? String
        
        let timestampString = dictionary["created_at"] as? String
        if let timestampString = timestampString {
            let formatter = DateFormatter()
            formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
            timestamp = formatter.date(from: timestampString)
        }
        
        retweetCount = (dictionary["retweet_count"] as? Int) ?? 0
        likeCount = (dictionary["favorite_count"] as? Int) ?? 0
        id = (dictionary["id"] as? NSNumber) ?? 0
        
        let userDictionary = dictionary["user"] as? NSDictionary
        if let userDictionary = userDictionary {
            user = User(dictionary: userDictionary) 
        }
        
        retweeted = (dictionary["retweeted"] as? Bool)!
        liked = (dictionary["favorited"] as? Bool)!
    }
    
    class func tweetsWithArray(dictionaries: [NSDictionary]) -> [Tweet] {
        var tweets = [Tweet]()
    
        for dictionary in dictionaries {
            let tweet = Tweet(dictionary: dictionary)
            tweets.append(tweet)
        }
    
        return tweets
    }
}
