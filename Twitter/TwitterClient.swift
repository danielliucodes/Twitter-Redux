//
//  TwitterClient.swift
//  Twitter
//
//  Created by Daniel Liu on 11/19/16.
//  Copyright © 2016 Daniel Liu. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class TwitterClient: BDBOAuth1SessionManager {
    
    static let sharedInstance = TwitterClient(baseURL: URL(string: "https://api.twitter.com")!, consumerKey: "8R2BEH7E348iMKDAekn1sCG0l", consumerSecret: "dz9aBRlRFdcN13T1Nz4tE6KffokEGwzHXOwg2sfgqhlRvl5VUY")!
    
    var loginSuccess: (() -> ())?
    var loginFailure: ((Error) -> ())?
    
    func login(success: @escaping () -> (), failure: @escaping (Error) -> ()) {
        loginSuccess = success
        loginFailure = failure
        
        deauthorize()
        fetchRequestToken(withPath: "oauth/request_token", method: "GET", callbackURL: URL(string: "twitter://oauth"), scope: nil, success: { (requestToken: BDBOAuth1Credential?) -> Void in
            
            if let token = requestToken?.token {
                let url = URL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(token)")!
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }, failure: { (error: Error?) -> Void in
            print("error: \(error?.localizedDescription)")
            self.loginFailure?(error!)
        })
    }
    
    func logout() {
        User.currentUser = nil
        deauthorize()
        
        NotificationCenter.default.post(name: User.userDidLogoutNotification, object: nil)
    }
    
    func homeTimeline(success: @escaping ([Tweet]) -> (), failure: @escaping (Error) -> ()) {
        get("1.1/statuses/home_timeline.json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) -> Void in
            let dictionaries = response as! [NSDictionary]
            
            let tweets = Tweet.tweetsWithArray(dictionaries: dictionaries)
            
            success(tweets)
            
        }, failure: { (task: URLSessionDataTask?, error: Error) -> Void in
            failure(error)
        })
    }
    
    func currentAccount(success: @escaping (User) -> (), failure: @escaping (Error) -> ()) {
        get("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) -> Void in
            
            let userDictionary = response as! NSDictionary
            let user = User(dictionary: userDictionary)
            
            success(user)
            
        }, failure: { (task: URLSessionDataTask?, error: Error) -> Void in
            failure(error)
        })
    }
    
    func postTweet(tweetText: String, replyId: NSNumber?, success: @escaping () -> (), failure: @escaping (Error) -> ()) {
        var parameters: [String: Any] = ["status": tweetText]
        if replyId != 0 {
            parameters["in_reply_to_status_id"] = replyId
        }
        
        post("1.1/statuses/update.json", parameters: parameters, progress: nil, success: { (task: URLSessionDataTask, response: Any?) -> Void in
            success()
        }, failure: { (task: URLSessionDataTask?, error: Error) -> Void in
            failure(error)
        })
    }
    
    func retweetTweet(id: NSNumber, success: @escaping () -> (), failure: @escaping (Error) -> ()) {
        post("1.1/statuses/retweet/\(id).json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) -> Void in
            success()
        }, failure: { (task: URLSessionDataTask?, error: Error) -> Void in
            failure(error)
        })
    }
    
    func unretweetTweet(id: NSNumber, success: @escaping () -> (), failure: @escaping (Error) -> ()) {
        post("1.1/statuses/unretweet/\(id).json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) -> Void in
            success()
        }, failure: { (task: URLSessionDataTask?, error: Error) -> Void in
            failure(error)
        })
    }
    
    func likeTweet(id: NSNumber, success: @escaping () -> (), failure: @escaping (Error) -> ()) {
        let parameters: NSDictionary = ["id": id]
        post("1.1/favorites/create.json", parameters: parameters, progress: nil, success: { (task: URLSessionDataTask, response: Any?) -> Void in
            success()
        }, failure: { (task: URLSessionDataTask?, error: Error) -> Void in
            failure(error)
        })
    }
    
    func unlikeTweet(id: NSNumber, success: @escaping () -> (), failure: @escaping (Error) -> ()) {
        let parameters: NSDictionary = ["id": id]
        post("1.1/favorites/destroy.json", parameters: parameters, progress: nil, success: { (task: URLSessionDataTask, response: Any?) -> Void in
            success()
        }, failure: { (task: URLSessionDataTask?, error: Error) -> Void in
            failure(error)
        })
    }
    
    func user(screenname: String, success: @escaping (User) -> (), failure: @escaping (Error) -> ()) {
        let parameters: NSDictionary = ["screen_name": screenname]
        
        get("1.1/users/show.json", parameters: parameters, progress: nil, success: { (task: URLSessionDataTask, response: Any?) -> Void in
            let userDictionary = response as! NSDictionary
            let user = User(dictionary: userDictionary)
            success(user)
        }, failure: { (task: URLSessionDataTask?, error: Error) -> Void in
            failure(error)
        })
    }
    
    func userTimeline(screenname: String, success: @escaping ([Tweet]) -> (), failure: @escaping (Error) -> ()) {
        let parameters: NSDictionary = ["screen_name": screenname]
        
        get("1.1/statuses/user_timeline.json", parameters: parameters, progress: nil, success: { (task: URLSessionDataTask, response: Any?) -> Void in
            let dictionaries = response as! [NSDictionary]
            
            let tweets = Tweet.tweetsWithArray(dictionaries: dictionaries)
            
            success(tweets)
            
        }, failure: { (task: URLSessionDataTask?, error: Error) -> Void in
            failure(error)
        })
    }
    
    func handleOpenUrl(url: URL) {
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        
        fetchAccessToken(withPath: "oauth/access_token", method: "POST", requestToken: requestToken, success: { (accessToken: BDBOAuth1Credential?) -> Void in
            
            self.currentAccount(success: { (user: User) in
                User.currentUser = user
                NotificationCenter.default.post(name: User.userDidLoginNotification, object: nil)
                self.loginSuccess?()
            }, failure: { (error: Error) in
                self.loginFailure?(error)
            })
            
        }, failure: { (error: Error?) -> Void in
            self.loginFailure?(error!)
        })
    }
    
    class func calculateTimeDifference(dateOfTweet: Date) -> String {
        let difference = dateOfTweet.timeIntervalSinceNow * -1
        
        // difference is in seconds
        if difference <= 60 {
            // seconds
            return "\(Int(difference))s"
        } else if difference > 60 && difference <= 3600 {
            // minutes
            return "\(Int(difference/60))m"
        } else if difference > 3600 && difference <= 216000 {
            // hours
            return "\(Int(difference/3600))h"
        } else if difference > 216000 && difference <= 12960000 {
            // days
            return "\(Int(difference/216000))d"
        } else {
            // years
            return "\(Int(difference/12960000))y"
        }
        
    }

}
