//
//  DetailsViewController.m
//  twitter
//
//  Created by lucyyyw on 7/3/19.
//  Copyright © 2019 Emerson Malca. All rights reserved.
//

#import "DetailsViewController.h"
#import "UIImageView+AFNetworking.h"
#import "APIManager.h"
#import "tweetCell.h"

@interface DetailsViewController () <TTTAttributedLabelDelegate>

@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self refreshData];
    
    
}


- (IBAction)ditTapRetweet:(id)sender {
    UIButton *retweetbtn = (UIButton *)sender;
    
    if (self.tweet.retweeted == NO)
    {
        [retweetbtn setImage:[UIImage imageNamed:@"retweet-icon-green.png"] forState:UIControlStateNormal];
        self.tweet.retweeted = YES;
        self.tweet.retweetCount += 1;
        [[APIManager shared] retweet:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if(error){
                NSLog(@"Error retweeting: %@", error.localizedDescription);
            }
            else{
                NSLog(@"Successfully retweeted the following Tweet: %@", tweet.text);
            }
        }];
    }
    else
    {
        [retweetbtn setImage:[UIImage imageNamed:@"retweet-icon.png"] forState:UIControlStateNormal];
        self.tweet.retweeted = NO;
        self.tweet.retweetCount -= 1;
        [[APIManager shared] unretweet:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if(error){
                NSLog(@"Error unretweeting: %@", error.localizedDescription);
            }
            else{
                NSLog(@"Successfully unretweeted the following Tweet: %@", tweet.text);
            }
        }];
    }
    [self refreshData];
}

- (IBAction)didTapLike:(id)sender {
    UIButton *likebtn = (UIButton *)sender;
    
    if (self.tweet.favorited == NO)
    {
        [likebtn setImage:[UIImage imageNamed:@"favor-icon-red.png"] forState:UIControlStateNormal];
        self.tweet.favorited = YES;
        self.tweet.favoriteCount += 1;
        [[APIManager shared] favorite:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if(error){
                NSLog(@"Error favoriting tweet: %@", error.localizedDescription);
            }
            else{
                NSLog(@"Successfully favorited the following Tweet: %@", tweet.text);
            }
        }];
    }
    else
    {
        [likebtn setImage:[UIImage imageNamed:@"favor-icon.png"] forState:UIControlStateNormal];
        self.tweet.favorited = NO;
        self.tweet.favoriteCount -= 1;
        [[APIManager shared] unfavorite:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if(error){
                NSLog(@"Error unfavoriting tweet: %@", error.localizedDescription);
            }
            else{
                NSLog(@"Successfully unfavorited the following Tweet: %@", tweet.text);
            }
        }];
    }
    
    [self refreshData];
}

- (void) refreshData {
    NSURL *url = [NSURL URLWithString:self.tweet.user.profileImageUrl];
    [self.profileImageView setImageWithURL:url];
    
    self.userNameLabel.text = self.tweet.user.name;
    self.screenNameLabel.text = [@"@" stringByAppendingString: self.tweet.user.screenName];
    self.dateLabel.text = (NSAttributedString *)self.tweet.createdAtString;
    
    self.tweetTextLabel.enabledTextCheckingTypes = NSTextCheckingTypeLink; // Automatically detect links when the label text is subsequently changed
    self.tweetTextLabel.delegate = self;
    
    
    self.tweetTextLabel.text = self.tweet.text;
    
    
    NSMutableString *retweetString = [@"" mutableCopy];
    if (self.tweet.retweetCount > 0) {
        retweetString = [NSMutableString stringWithFormat:@"%i retweet",self.tweet.retweetCount];
    } else if (self.tweet.retweetCount > 1) {
        [retweetString appendString:@"s"];
    }
    
    
    NSMutableString *likeString = [@"" mutableCopy];
    if (self.tweet.favoriteCount > 0) {
        likeString = [NSMutableString stringWithFormat:@"   %i likes",self.tweet.favoriteCount];
    } else if (self.tweet.favoriteCount > 1) {
        [likeString appendString:@"s"];
    }
    
    self.feedBackLabel.text = [retweetString stringByAppendingString:likeString];
    
    if (self.tweet.favorited == NO) {
        [self.likeButton setImage:[UIImage imageNamed:@"favor-icon.png"] forState:UIControlStateNormal];
    } else {
        [self.likeButton setImage:[UIImage imageNamed:@"favor-icon-red.png"] forState:UIControlStateNormal];
    }
    
    if (self.tweet.retweeted == NO) {
        [self.retweetButton setImage:[UIImage imageNamed:@"retweet-icon.png"] forState:UIControlStateNormal];
    } else {
        [self.retweetButton setImage:[UIImage imageNamed:@"retweet-icon-green.png"] forState:UIControlStateNormal];
    }
    
    [self.tweetCell refreshData];
    [self.tableView reloadData];
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
