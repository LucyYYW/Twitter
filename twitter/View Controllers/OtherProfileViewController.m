//
//  OtherProfileViewController.m
//  twitter
//
//  Created by lucyyyw on 7/4/19.
//  Copyright © 2019 Emerson Malca. All rights reserved.
//

#import "OtherProfileViewController.h"
#import "User.h"
#import "APIManager.h"
#import "TTTAttributedLabel.h"
#import "UIImageView+AFNetworking.h"
#import "TweetCell.h"

@interface OtherProfileViewController () <UITableViewDataSource, UITableViewDelegate, TTTAttributedLabelDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet TTTAttributedLabel *userNameLabel;
@property (weak, nonatomic) IBOutlet TTTAttributedLabel *screenNameLabel;
@property (weak, nonatomic) IBOutlet TTTAttributedLabel *numTweetsLabel;
@property (weak, nonatomic) IBOutlet TTTAttributedLabel *numFollowingLabel;
@property (weak, nonatomic) IBOutlet UILabel *numFollowerLabel;
@property (weak, nonatomic) IBOutlet UITableView *tweetsTableView;

@property (nonatomic, strong) NSMutableArray *tweets;



@end

@implementation OtherProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tweetsTableView.dataSource = self;
    self.tweetsTableView.delegate = self;
    
    [self.profileImageView setImageWithURL:[NSURL URLWithString: self.user.profileImageUrl]];
    self.userNameLabel.text = self.user.name;
    self.screenNameLabel.text = [@"@" stringByAppendingString: self.user.screenName];
    self.numTweetsLabel.text = [NSString stringWithFormat:@"%i tweets", self.user.tweetsCount];
    self.numFollowingLabel.text = [NSString stringWithFormat:@"%i Following", self.user.followingCount];
    NSMutableString *followerText = [[NSString stringWithFormat:@"%i Follower", self.user.followerCount] mutableCopy];
    if (self.user.followerCount > 1) {
        [followerText appendString:@"s"];
    }
    self.numFollowerLabel.text = followerText;
    
    [self getUserTweets];
    
    
    self.tweetsTableView.rowHeight = UITableViewAutomaticDimension;
    
}

/*
- (void) getUserInfo {
    [[APIManager shared] getUserWithScreenname: @"MiSuerteCR7" completion:^(NSDictionary *userDictionary, NSError *error) {
        if (userDictionary) {
            NSLog(@"😎😎😎 Successfully loaded user profile");
            self.user = [[User alloc] initWithDictionary :userDictionary];
            
            [self.profileImageView setImageWithURL:[NSURL URLWithString: self.user.profileImageUrl]];
            self.userNameLabel.text = self.user.name;
            self.screenNameLabel.text = [@"@" stringByAppendingString: self.user.screenName];
            self.numTweetsLabel.text = [NSString stringWithFormat:@"%i tweets", self.user.tweetsCount];
            self.numFollowingLabel.text = [NSString stringWithFormat:@"%i Following", self.user.followingCount];
            NSMutableString *followerText = [[NSString stringWithFormat:@"%i Follower", self.user.followerCount] mutableCopy];
            if (self.user.followerCount > 1) {
                [followerText appendString:@"s"];
            }
            self.numFollowersLabel.text = followerText;
            
            [self getUserTweets];
            
        } else {
            NSLog(@"😫😫😫 Error getting user info: %@", error.localizedDescription);
        }
        
        
        
    }];
}
 */

- (void) getUserTweets {
    
    [[APIManager shared] getTweetsWithScreenname: self.user.screenName completion:^(NSArray *tweets, NSError *error) {
        if (tweets) {
            NSLog(@"😎😎😎 Successfully loaded user timeline");
            
            //6. View controller stores that data passed into the completion handler
            self.tweets = [tweets mutableCopy];
            
            
            //7. Reload the tableView now that there is new data
            [self.tweetsTableView reloadData];
            
            
            
        } else {
            NSLog(@"😫😫😫 Error getting user timeline: %@", error.localizedDescription);
        }
        
        
    }];
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    TweetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ProfileTweetCell"];
    
    Tweet *tweet = self.tweets[indexPath.row];
    
    cell.tweet = tweet;
    
    NSURL *url = [NSURL URLWithString:tweet.user.profileImageUrl];
    [cell.profileImageView setImageWithURL:url];
    cell.userNameLabel.text = tweet.user.name;
    cell.screenNameLabel.text = [@"@" stringByAppendingString: tweet.user.screenName];
    cell.dateLabel.text = (NSAttributedString *)tweet.timeAgoString;
    
    
    cell.tweetTextLabel.enabledTextCheckingTypes = NSTextCheckingTypeLink; // Automatically detect links when the label text is subsequently changed
    cell.tweetTextLabel.delegate = self;
    
    
    cell.tweetTextLabel.text = tweet.text;
    
    
    cell.replyLabel.text = [NSString stringWithFormat:@"%i", tweet.replyCount];
    cell.retweetLabel.text = [NSString stringWithFormat:@"%i", tweet.retweetCount];
    cell.likeLabel.text = [NSString stringWithFormat:@"%i", tweet.favoriteCount];
    
    if (tweet.favorited == NO) {
        [cell.likeButton setImage:[UIImage imageNamed:@"favor-icon.png"] forState:UIControlStateNormal];
    } else {
        [cell.likeButton setImage:[UIImage imageNamed:@"favor-icon-red.png"] forState:UIControlStateNormal];
    }
    
    if (tweet.retweeted == NO) {
        [cell.retweetButton setImage:[UIImage imageNamed:@"retweet-icon.png"] forState:UIControlStateNormal];
    } else {
        [cell.retweetButton setImage:[UIImage imageNamed:@"retweet-icon-green.png"] forState:UIControlStateNormal];
    }
    
    return cell;
    
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tweets.count;
}

- (void)attributedLabel:(TTTAttributedLabel *)label
   didSelectLinkWithURL:(NSURL *)url {
    UIApplication *application = [UIApplication sharedApplication];
    [application openURL:url options:@{} completionHandler:nil];
    
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
