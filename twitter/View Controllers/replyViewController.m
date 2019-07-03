//
//  replyViewController.m
//  twitter
//
//  Created by lucyyyw on 7/3/19.
//  Copyright © 2019 Emerson Malca. All rights reserved.
//

#import "replyViewController.h"
#import "APIManager.h"

@interface replyViewController ()

@property (weak, nonatomic) IBOutlet UITextView *replyTextView;

@end


@implementation replyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)onClose:(id)sender {
    [self dismissViewControllerAnimated:true completion: nil];
}


- (IBAction)onReply:(id)sender {
    NSLog(@"tweet clicked");
    [[APIManager shared] replyWithText: self.replyTextView.text toTweet: self.tweet completion:^(Tweet *tweet, NSError *error) {
        if (tweet) {
            NSLog(@"😎😎😎 Successfully replied a new tweet");
            self.tweet.replyCount += 1;
            
        } else {
            NSLog(@"😫😫😫 Error replying: %@", error.localizedDescription);
        }
        
    }];
    [self.tableView reloadData];
    [self dismissViewControllerAnimated:true completion: nil];
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
