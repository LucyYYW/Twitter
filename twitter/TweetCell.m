//
//  TweetCell.m
//  twitter
//
//  Created by lucyyyw on 7/1/19.
//  Copyright © 2019 Emerson Malca. All rights reserved.
//

#import "TweetCell.h"
#import "UIImageView+AFNetworking.h"
#import "APIManager.h"


@implementation TweetCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    UITapGestureRecognizer *profileTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didTapUserProfile:)];
    [self.profileImageView addGestureRecognizer:profileTapGestureRecognizer];
    [self.profileImageView setUserInteractionEnabled:YES];
    
    UITapGestureRecognizer *replyTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didTapReply:)];
    [self.replyButton addGestureRecognizer:replyTapGestureRecognizer];
    [self.replyButton setUserInteractionEnabled:YES];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)didTapRetweet:(id)sender {
    
    UIButton *retweetbtn = (UIButton *)sender;
    
    //if( [[likebtn imageForState:UIControlStateNormal] isEqual:[UIImage imageNamed:@"favor-icon.png"]])
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
    
    //if( [[likebtn imageForState:UIControlStateNormal] isEqual:[UIImage imageNamed:@"favor-icon.png"]])
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
    self.dateLabel.text = self.tweet.createdAtString;
    self.tweetTextLabel.text = self.tweet.text;
    self.replyLabel.text = [NSString stringWithFormat:@"%i", self.tweet.replyCount];
    self.retweetLabel.text = [NSString stringWithFormat:@"%i", self.tweet.retweetCount];
    self.likeLabel.text = [NSString stringWithFormat:@"%i", self.tweet.favoriteCount];
}

- (void) didTapUserProfile:(UITapGestureRecognizer *)sender{
    // TODO: Call method on delegate
    [self.delegate tweetCell:self didTap:self.tweet.user];
    
}

- (void) didTapReply:(UITapGestureRecognizer *)sender{
    // TODO: Call method on delegate
    [self.delegate replyTweetCell:self didTap:self.tweet];
}



@end
