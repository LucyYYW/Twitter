//
//  profileViewController.m
//  twitter
//
//  Created by lucyyyw on 7/3/19.
//  Copyright © 2019 Emerson Malca. All rights reserved.
//

#import "profileViewController.h"
#import "User.h"
#import "APIManager.h"
#import "TTTAttributedLabel.h"
#import "UIImageView+AFNetworking.h"

@interface profileViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet TTTAttributedLabel *userNameLabel;
@property (weak, nonatomic) IBOutlet TTTAttributedLabel *screenNameLabel;
@property (weak, nonatomic) IBOutlet TTTAttributedLabel *numTweetsLabel;
@property (weak, nonatomic) IBOutlet TTTAttributedLabel *numFollowingLabel;
@property (weak, nonatomic) IBOutlet TTTAttributedLabel *numFollowersLabel;

@end

@implementation profileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[APIManager shared] getUserWithScreenname: @"MiSuerteCR7" completion:^(User* user, NSError *error) {
        if (user) {
            NSLog(@"😎😎😎 Successfully loaded home timeline");
         
            [self.profileImageView setImageWithURL:[NSURL URLWithString: user.profileImageUrl]];
            self.userNameLabel.text = user.name;
            self.screenNameLabel.text = [@"@" stringByAppendingString: user.screenName];
            self.numTweetsLabel.text = [NSString stringWithFormat:@"%i tweets", user.tweetsCount];
            self.numFollowingLabel.text = [NSString stringWithFormat:@"%i Following", user.followingCount];
            NSMutableString *followerText = [[NSString stringWithFormat:@"%i Follower", user.followerCount] mutableCopy];
            if (user.followerCount > 1) {
                [followerText appendString:@"s"];
            }
            self.numFollowersLabel.text = followerText;
            
        } else {
            NSLog(@"😫😫😫 Error getting home timeline: %@", error.localizedDescription);
        }
        
        
        
    }];
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
