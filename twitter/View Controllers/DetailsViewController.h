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

@property (strong,nonatomic) Tweet *tweet;

@end

NS_ASSUME_NONNULL_END
