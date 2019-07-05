//
//  DetailsViewController.h
//  twitter
//
//  Created by lucyyyw on 7/3/19.
//  Copyright © 2019 Emerson Malca. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TweetCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface DetailsViewController : UIViewController
@property (weak, nonatomic) IBOutlet TTTAttributedLabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet TTTAttributedLabel *screenNameLabel;

@property (weak, nonatomic) IBOutlet TTTAttributedLabel *tweetTextLabel;

@property (weak, nonatomic) IBOutlet TTTAttributedLabel *dateLabel;
@property (weak, nonatomic) IBOutlet TTTAttributedLabel *feedBackLabel;
@property (weak, nonatomic) IBOutlet UIButton *retweetButton;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (weak, nonatomic) IBOutlet UIButton *replyButton;

@property (strong,nonatomic) Tweet *tweet;
@property (strong,nonatomic) TweetCell *tweetCell;
@property (strong,nonatomic) UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *mediaImageView;

@end

NS_ASSUME_NONNULL_END
