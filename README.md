# Twitter

This is the Twitter project.

Time spent: 14 hours spent in total

Completed user stories:

* [x] User can sign in using OAuth login flow
* [x] User can view last 20 tweets from their home timeline
* [x] The current signed in user will be persisted across restarts
* [x] In the home timeline, user can view tweet with the user profile picture, username, tweet text, and timestamp. In other words, design the custom cell with the proper Auto Layout settings. You will also need to augment the model classes.
* [x] User can pull to refresh
* [x] User can compose a new tweet by tapping on a compose button.

Notes:

Optional features not completed as focus is on completing all required assignments to catch up.
The following issues were faced:
  
  Twitter API
    - API rate limit caused many test runs to fail, like not retrieving timelines or posting Tweets.
  
  Auto Layout
    - Ran into some issues of Auto Layout causing text not to show.
    
   Reusable Table Cell
    - Could not figure out how to get the Tweet details view, which had a lot of overlap with Tweets timeline view, yet needed action buttoms. Ended up hacking by using an enum count.
   
Walkthrough of all user stories:

![Video Walkthrough](VideoWalkthrough.gif)

We start already signed in to show the persisted timeline. Then we tap on a specific tweet to see its details, and like/unlike and retweet/unretweet. We then post a new Tweet and it reflects in the timeline. Finally we logout/login and we see the mentioned API rate limit issue.

GIF created with [LiceCap](http://www.cockos.com/licecap/).
