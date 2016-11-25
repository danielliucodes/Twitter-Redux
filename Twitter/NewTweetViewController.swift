//
//  NewTweetViewController.swift
//  Twitter
//
//  Created by Daniel Liu on 11/24/16.
//  Copyright © 2016 Daniel Liu. All rights reserved.
//

import UIKit

@objc protocol NewTweetViewControllerDelegate {
    func newTweetViewController(newTweetViewController: NewTweetViewController, tweet: Tweet)
}

class NewTweetViewController: UIViewController, UITextViewDelegate {
    
    weak var delegate: NewTweetViewControllerDelegate?
    
    @IBOutlet weak var newTweetView: NewTweetView!
    
    @IBOutlet weak var tweetTextView: UITextView!
    @IBOutlet weak var charactersLimitTextField: UITextField!
    
    var charactersCountLimit = 140
    var currentCharactersCount = 0
    var replyTweet: Tweet?
    var retweetTweet: Tweet?
    var user: User!
    var newTweetText: String = ""
    
    let alertController = UIAlertController(title: "Error", message: "Cannot post Tweet", preferredStyle: .alert)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
       tweetTextView.delegate = self
        
        if let replyTweet = replyTweet {
            if let screenname = replyTweet.user?.screenname {
                newTweetText += "@\(screenname) "
            }
        }
        
        if let retweetTweet = retweetTweet {
            if let name = retweetTweet.user?.name {
                newTweetText += "\(name) "
            }
            
            if let screenname = retweetTweet.user?.screenname {
                newTweetText += "@\(screenname) "
            }
            
            if let text = retweetTweet.text {
                newTweetText += "\(text) "
            }
        }
        
        newTweetView.user = user
        newTweetView.postView.text = newTweetText
        
        currentCharactersCount = newTweetText.characters.count
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textViewDidChange(_ textView: UITextView) {
        newTweetText = tweetTextView.text!
        currentCharactersCount = newTweetText.characters.count
        charactersLimitTextField.text = "\(currentCharactersCount)/\(charactersCountLimit)"
    }
    
    @IBAction func onCancelTap(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func onTweetTap(_ sender: Any) {
        if currentCharactersCount == 0 {
            alertController.message = "Tweet is empty! Add something to say!"
            let cancelAction = UIAlertAction(title: "OK", style: .cancel)
            alertController.addAction(cancelAction)
            present(alertController, animated: true)
        } else if currentCharactersCount > charactersCountLimit {
            alertController.message = "Too many characters! Shorten your post please!"
            let cancelAction = UIAlertAction(title: "OK", style: .cancel)
            alertController.addAction(cancelAction)
            present(alertController, animated: true)
        } else {
            let formatter = DateFormatter()
            formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
            let now = formatter.string(from: Date())
            
            TwitterClient.sharedInstance.postTweet(tweetText: newTweetText, replyId: replyTweet?.id, success: { () -> () in
                let tweetDictionary: NSDictionary = ["text": self.newTweetText, "created_at": now, "retweet_cunt": 0, "favourites_count": 0, "user": self.user.dictionary!, "retweeted": false, "favorited": false]
                let tweet = Tweet.init(dictionary: tweetDictionary)
                
                self.delegate?.newTweetViewController(newTweetViewController: self, tweet: tweet)
                self.dismiss(animated: true, completion: nil)
            }, failure: { (error: Error) -> () in
                print("error: \(error.localizedDescription)")
            })

        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
