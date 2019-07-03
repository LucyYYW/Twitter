//
//  replyViewController.h
//  twitter
//
//  Created by lucyyyw on 7/3/19.
//  Copyright © 2019 Emerson Malca. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"


NS_ASSUME_NONNULL_BEGIN



@interface replyViewController : UIViewController

@property (strong, nonatomic) Tweet *tweet;

@property (strong, nonatomic) UITableView *tableView;

@end

NS_ASSUME_NONNULL_END
