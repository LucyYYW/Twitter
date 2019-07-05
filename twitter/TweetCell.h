//
//  TweetCell.h
//  twitter
//
//  Created by lucyyyw on 7/1/19.
//  Copyright © 2019 Emerson Malca. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTTAttributedLabel.h"
#import "Tweet.h"
#import "User.h"

NS_ASSUME_NONNULL_BEGIN

@protocol TweetCellDelegate;

@interface TweetCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet TTTAttributedLabel *userNameLabel;

@property (weak, nonatomic) IBOutlet TTTAttributedLabel *screenNameLabel;
@property (weak, nonatomic) IBOutlet TTTAttributedLabel *dateLabel;
@property (weak, nonatomic) IBOutlet TTTAttributedLabel *tweetTextLabel;
@property (weak, nonatomic) IBOutlet TTTAttributedLabel *replyLabel;
@property (weak, nonatomic) IBOutlet TTTAttributedLabel *retweetLabel;
@property (weak, nonatomic) IBOutlet TTTAttributedLabel *likeLabel;

@property (weak, nonatomic) IBOutlet UIButton *replyButton;

@property (weak, nonatomic) IBOutlet UIButton *retweetButton;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;

@property (weak, nonatomic) IBOutlet UIImageView *mediaImageView;

@property (strong, nonatomic) Tweet *tweet;

- (void) refreshData;


@property (nonatomic, weak) id<TweetCellDelegate> delegate;

@end


@protocol TweetCellDelegate
- (void)tweetCell:(TweetCell *) tweetCell didTap: (User *)user;
@end






NS_ASSUME_NONNULL_END
